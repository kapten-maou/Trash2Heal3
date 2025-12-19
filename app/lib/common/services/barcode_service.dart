import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Barcode Service for QR Code generation and scanning
class BarcodeService {
  static final BarcodeService _instance = BarcodeService._internal();
  factory BarcodeService() => _instance;
  BarcodeService._internal();

  // ============================================
  // QR CODE GENERATION
  // ============================================

  /// Generate QR Code widget
  Widget generateQRCode({
    required String data,
    double size = 200.0,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsets padding = const EdgeInsets.all(10),
  }) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor ?? Colors.white,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: foregroundColor ?? Colors.black,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foregroundColor ?? Colors.black,
      ),
      padding: padding,
    );
  }

  /// Generate coupon QR code with custom design
  Widget generateCouponQR({
    required String couponCode,
    required String eventName,
    double size = 250.0,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // QR Code
          generateQRCode(
            data: couponCode,
            size: size,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          
          const SizedBox(height: 16),
          
          // Coupon Code
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              couponCode,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFamily: 'monospace',
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Event Name
          Text(
            eventName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Generate membership QR code
  Widget generateMembershipQR({
    required String userId,
    required String planName,
    double size = 200.0,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const Row(
            children: [
              Icon(Icons.card_membership, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Membership Card',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // QR Code
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: generateQRCode(
              data: userId,
              size: size,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Plan Name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              planName.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // QR CODE SCANNING
  // ============================================

  /// Show QR code scanner screen
  Future<String?> scanQRCode(BuildContext context) async {
    return await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const _QRScannerScreen(),
      ),
    );
  }

  /// Show barcode scanner with custom UI
  Future<String?> scanBarcode(
    BuildContext context, {
    String title = 'Scan Barcode',
    String description = 'Arahkan kamera ke barcode',
  }) async {
    return await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => _QRScannerScreen(
          title: title,
          description: description,
        ),
      ),
    );
  }

  /// Scan coupon for event redemption
  Future<String?> scanCouponForEvent(
    BuildContext context,
    String eventName,
  ) async {
    return await scanBarcode(
      context,
      title: 'Scan Kupon',
      description: 'Scan kupon untuk event $eventName',
    );
  }

  // ============================================
  // VALIDATION
  // ============================================

  /// Validate coupon code format
  bool isValidCouponCode(String code) {
    // Format: COUP-XXXX-XXXX (e.g., COUP-1234-ABCD)
    final regex = RegExp(r'^COUP-[A-Z0-9]{4}-[A-Z0-9]{4}$');
    return regex.hasMatch(code);
  }

  /// Validate event item code format
  bool isValidEventItemCode(String code) {
    // Format: EVENT-XXXX-ITEM-XXXX
    final regex = RegExp(r'^EVENT-[A-Z0-9]{4}-ITEM-[A-Z0-9]{4}$');
    return regex.hasMatch(code);
  }

  /// Extract coupon ID from QR code
  String? extractCouponId(String qrData) {
    if (isValidCouponCode(qrData)) {
      return qrData;
    }
    return null;
  }
}

// ============================================
// QR SCANNER SCREEN
// ============================================

class _QRScannerScreen extends StatefulWidget {
  final String title;
  final String description;

  const _QRScannerScreen({
    this.title = 'Scan QR Code',
    this.description = 'Arahkan kamera ke QR code',
  });

  @override
  State<_QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<_QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;
  bool _hasPermission = true;
  String? _scannerError;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final code = barcode.rawValue;

    if (code != null && code.isNotEmpty) {
      setState(() {
        _isProcessing = true;
      });

      // Vibrate
      // HapticFeedback.mediumImpact();

      // Return result
      Navigator.pop(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Preview
          MobileScanner(
            controller: cameraController,
            onDetect: _handleBarcode,
            errorBuilder: (context, error, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                setState(() {
                  _scannerError = error.errorCode.name;
                  if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
                    _hasPermission = false;
                  }
                });
              });
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Kamera tidak dapat dibuka (${error.errorCode.name}).',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Overlay
          CustomPaint(
            painter: _ScannerOverlayPainter(),
            child: Container(),
          ),

          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          if (!_hasPermission || _scannerError != null)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, size: 40, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        _scannerError != null
                            ? 'Kamera tidak tersedia ($_scannerError).'
                            : 'Izin kamera diperlukan untuk memindai.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Processing Indicator
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================
// SCANNER OVERLAY PAINTER
// ============================================

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final scanArea = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.7,
      height: size.width * 0.7,
    );

    // Draw overlay with cutout
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(scanArea, const Radius.circular(16)),
          ),
      ),
      paint,
    );

    // Draw corners
    final cornerPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const cornerLength = 30.0;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left, scanArea.top + cornerLength)
        ..lineTo(scanArea.left, scanArea.top)
        ..lineTo(scanArea.left + cornerLength, scanArea.top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right - cornerLength, scanArea.top)
        ..lineTo(scanArea.right, scanArea.top)
        ..lineTo(scanArea.right, scanArea.top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left, scanArea.bottom - cornerLength)
        ..lineTo(scanArea.left, scanArea.bottom)
        ..lineTo(scanArea.left + cornerLength, scanArea.bottom),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right - cornerLength, scanArea.bottom)
        ..lineTo(scanArea.right, scanArea.bottom)
        ..lineTo(scanArea.right, scanArea.bottom - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================
// PROVIDER (for Riverpod)
// ============================================



/// Barcode Service provider
final barcodeServiceProvider = Provider<BarcodeService>((ref) {
  return BarcodeService();
});
