import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trash2heal_app/core/constants/app_images.dart';
import '../../providers/auth_provider.dart';
import '../../../../common/widgets/tab_switcher.dart';
import '../../../../common/widgets/form_card.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/password_field.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/secondary_button.dart';
import '../../../../common/widgets/error_banner.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int _selectedRoleIndex = 0; // 0 = User, 1 = Courier

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final role = _selectedRoleIndex == 0 ? UserRole.user : UserRole.courier;

    final success = await ref.read(authProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: role,
          courierAccessCode: null,
        );

    if (!mounted) return;

    if (success) {
      if (role == UserRole.courier) {
        context.go('/courier/tasks');
      } else {
        context.go('/home');
      }
    }
  }

  void _handleGuestLogin() {
    ref.read(authProvider.notifier).loginAsGuest();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.recycling,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              // App Name
              Text(
                'TRASH2HEAL',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 32),

              // Tab Switcher
              TabSwitcher(
                selectedIndex: _selectedRoleIndex,
                tabs: const ['USER', 'KURIR'],
                onTabChanged: (index) {
                  setState(() {
                    _selectedRoleIndex = index;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Error Banner
              if (authState.errorMessage != null) ...[
                ErrorBanner(
                  message: authState.errorMessage!,
                  onDismiss: () {
                    ref.read(authProvider.notifier).clearError();
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Form Card
              FormCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Field
                      CustomTextField(
                        label: 'Email',
                        hintText: 'nama@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!value.contains('@')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                  PasswordField(
                    label: 'Password',
                    hintText: 'Masukkan password',
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      return null;
                    },
                  ),
                  // Kode akses kurir dihapus
                  const SizedBox(height: 8),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Login Button
                      PrimaryButton(
                        text: 'MASUK',
                        onPressed: _handleLogin,
                        isLoading: authState.isLoading,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Guest Login Button
              SecondaryButton(
                text: '+ Masuk sebagai Tamu',
                onPressed: _handleGuestLogin,
                isFullWidth: true,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
