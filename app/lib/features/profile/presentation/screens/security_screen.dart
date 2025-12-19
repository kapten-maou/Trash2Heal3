import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/profile_provider.dart';
import '../../../../common/widgets/password_field.dart';
import '../../../../common/widgets/primary_button.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref.read(profileProvider).changePassword(
          _currentPasswordController.text,
          _newPasswordController.text,
        );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah')),
      );
      // Clear form
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } else {
      final error =
          ref.read(profileProvider).error ?? 'Gagal mengubah password';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Gunakan password yang kuat dengan kombinasi huruf, angka, dan simbol.',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Change Password Section
              Text(
                'Ubah Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),

              // Current Password
              PasswordField(
                controller: _currentPasswordController,
                label: 'Password Saat Ini',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password saat ini tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // New Password
              PasswordField(
                controller: _newPasswordController,
                label: 'Password Baru',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password baru tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  if (value == _currentPasswordController.text) {
                    return 'Password baru harus berbeda dengan password lama';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Confirm Password
              PasswordField(
                controller: _confirmPasswordController,
                label: 'Konfirmasi Password Baru',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Save Button
              PrimaryButton(
                text: 'Ubah Password',
                isLoading: _isLoading,
                onPressed: _changePassword,
              ),

              const SizedBox(height: 48),

              // Other Security Options (Future features)
              Text(
                'Pengaturan Keamanan Lainnya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),

              _buildSecurityOption(
                icon: Icons.fingerprint,
                title: 'Autentikasi Biometrik',
                subtitle: 'Gunakan sidik jari atau Face ID',
                enabled: false,
                onChanged: (value) {
                  // TODO: Implement biometric
                },
              ),

              _buildSecurityOption(
                icon: Icons.pin,
                title: 'PIN Transaksi',
                subtitle: 'Keamanan tambahan untuk transaksi',
                enabled: false,
                onChanged: (value) {
                  // TODO: Implement PIN
                },
              ),

              const SizedBox(height: 16),

              const _PinSection(),

              // Forgot Password Link
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Link reset password akan dikirim ke email Anda'),
                    ),
                  );
                },
                child: const Text('Lupa Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(title),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        value: enabled,
        onChanged: onChanged,
      ),
    );
  }
}

class _PinSection extends StatefulWidget {
  const _PinSection();

  @override
  State<_PinSection> createState() => _PinSectionState();
}

class _PinSectionState extends State<_PinSection> {
  final _pinController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PIN Transaksi',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Set PIN 6 digit untuk verifikasi transaksi.',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pinController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'PIN 6 digit',
                counterText: '',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving
                    ? null
                    : () async {
                        setState(() => _isSaving = true);
                        await Future.delayed(
                            const Duration(milliseconds: 600));
                        if (!mounted) return;
                        setState(() => _isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('PIN tersimpan (dummy).'),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF18A558),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Simpan PIN',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
