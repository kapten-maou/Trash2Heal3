import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class MembershipPaymentWaitingScreen extends StatefulWidget {
  final String paymentId;
  final String? fallbackAmount;
  final String? fallbackCode;
  final Duration fallbackDuration;

  const MembershipPaymentWaitingScreen({
    super.key,
    required this.paymentId,
    this.fallbackAmount,
    this.fallbackCode,
    this.fallbackDuration = const Duration(minutes: 24),
  });

  @override
  State<MembershipPaymentWaitingScreen> createState() =>
      _MembershipPaymentWaitingScreenState();
}

class _MembershipPaymentWaitingScreenState
    extends State<MembershipPaymentWaitingScreen> {
  final _paymentRepo = PaymentRepository();
  PaymentModel? _payment;
  Duration _remaining = Duration.zero;
  Timer? _poller;
  Timer? _countdown;
  bool _isLoading = true;
  String? _error;
  Duration _pollDelay = const Duration(seconds: 5);
  bool _isPolling = false;
  static const _maxPollDelay = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _initPayment();
  }

  Future<void> _initPayment() async {
    try {
      final payment = await _paymentRepo.getPaymentById(widget.paymentId);
      setState(() {
        _payment = payment;
        _isLoading = false;
      });
      _startCountdown();
      _startPolling();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _poller?.cancel();
    _countdown?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    final expiry = _payment?.expiryDate;
    final target = expiry ?? DateTime.now().add(widget.fallbackDuration);
    _updateRemaining(target);
    _countdown = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining(target);
    });
  }

  void _updateRemaining(DateTime target) {
    final now = DateTime.now();
    final diff = target.difference(now);
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
      if (diff.isNegative) {
        _error ??= 'Pembayaran kedaluwarsa';
        _poller?.cancel();
      }
    });
  }

  void _startPolling() {
    _schedulePoll();
  }

  void _schedulePoll() {
    _poller?.cancel();
    setState(() {
      _isPolling = true;
    });
    _poller = Timer(_pollDelay, () async {
      final payment = await _paymentRepo.getPaymentById(widget.paymentId);
      if (payment == null) return;
      if (payment.status == PaymentStatus.paid) {
        _poller?.cancel();
        if (mounted) {
          context.go('/membership/success?paymentId=${payment.id}');
        }
        return;
      }

      if (payment.status == PaymentStatus.expired ||
          payment.status == PaymentStatus.failed) {
        _poller?.cancel();
        if (mounted) {
          setState(() {
            _error = 'Pembayaran ${payment.status.name}';
          });
        }
        return;
      }

      // Exponential backoff up to max delay
      _pollDelay = Duration(
        seconds:
            (_pollDelay.inSeconds * 2).clamp(5, _maxPollDelay.inSeconds),
      );
      if (mounted) {
        setState(() {
          _isPolling = false;
        });
      }
      _schedulePoll();
    });
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:$m:$s';
  }

  String get _displayAmount {
    if (_payment != null) {
      return 'Rp ${_payment!.totalAmount}';
    }
    return widget.fallbackAmount ?? 'Rp 0';
  }

  String get _displayCode {
    final code = _payment?.qrCode ?? _payment?.vaNumber;
    return code ?? widget.fallbackCode ?? '-';
  }

  String? get _qrImageUrl {
    final metadataUrl = _payment?.metadata?['qrImageUrl'] as String?;
    if (metadataUrl != null) return metadataUrl;

    final qr = _payment?.qrCode ?? _payment?.vaNumber;
    if (qr == null || qr.isEmpty) return null;
    if (qr.startsWith('http')) return qr;
    if (_looksLikeBase64(qr)) return qr;
    if (qr.startsWith('data:image')) return qr;
    return _buildQrImageUrl(qr);
  }

  bool get _isGatewayQr {
    final metadataUrl = _payment?.metadata?['qrImageUrl'] as String?;
    final qr = _payment?.qrCode;
    if (metadataUrl != null) return true;
    if (qr == null || qr.isEmpty) return false;
    return qr.startsWith('http') ||
        qr.startsWith('data:image') ||
        _looksLikeBase64(qr);
  }

  String get _methodLabel {
    if (_payment == null) return 'QR / VA';
    switch (_payment!.method) {
      case PaymentMethod.qris:
        return 'QRIS';
      case PaymentMethod.virtualAccount:
        return 'Virtual Account';
      case PaymentMethod.ewallet:
        return 'E-Wallet';
      default:
        return _payment!.method.name;
    }
  }

  String _buildQrImageUrl(String code) {
    final data = Uri.encodeComponent(code);
    return 'https://api.qrserver.com/v1/create-qr-code/?size=280x280&data=$data';
  }

  bool _looksLikeBase64(String input) {
    final base64Regex = RegExp(r'^[A-Za-z0-9+/=]+$');
    return base64Regex.hasMatch(input);
  }

  Widget _buildQrWidget() {
    final qr = _qrImageUrl;
    if (qr == null) {
      return const Center(
          child: Icon(Icons.qr_code, size: 120, color: Color(0xFF9CA3AF)));
    }

    if (qr.startsWith('data:image')) {
      final base64Str = qr.split(',').last;
      try {
        final bytes = base64Decode(base64Str);
        return Image.memory(bytes, fit: BoxFit.cover);
      } catch (_) {
        return const Center(
            child: Icon(Icons.qr_code, size: 120, color: Color(0xFF9CA3AF)));
      }
    }

    if (_looksLikeBase64(qr)) {
      try {
        final bytes = base64Decode(qr);
        return Image.memory(bytes, fit: BoxFit.cover);
      } catch (_) {
        // fall through to network
      }
    }

    return Image.network(
      qr,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.qr_code, size: 120, color: Color(0xFF9CA3AF)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MENUNGGU PEMBAYARAN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Color(0xFFEF4444)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                            color: Color(0xFFB91C1C), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Text(
              'Bayar dalam ${_formatDuration(_remaining)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF3F4F6),
              ),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildQrWidget(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_isGatewayQr)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF59E0B)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline,
                              size: 16, color: Color(0xFFF59E0B)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'QR ini placeholder. Jika tidak bisa scan, gunakan kode di bawah.',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF92400E)),
                            ),
                          )
                        ],
                      ),
                    ),
                  if (!_isGatewayQr) const SizedBox(height: 12),
                  Text(
                    'Metode: $_methodLabel',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Scan dengan aplikasi pembayaran Anda',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Atau',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    _displayCode,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _displayCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kode disalin')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('SALIN KODE'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _displayAmount,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pembayaran akan dikonfirmasi otomatis setelah berhasil',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: _isPolling
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Icon(Icons.schedule, size: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(width: 8),
                Text(
                  'Memeriksa status setiap ${_pollDelay.inSeconds}s',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/membership/success'),
                child: const Text('CEK STATUS PEMBAYARAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
