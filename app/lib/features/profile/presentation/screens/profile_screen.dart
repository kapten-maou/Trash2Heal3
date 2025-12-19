import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/profile_menu_item.dart';
import '../../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileProvider).loadCurrentUser();
    });
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final bytes = await image.readAsBytes();
    final provider = ref.read(profileProvider);

    // Show loading
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final url = await provider.uploadProfilePhoto(bytes);

    if (!mounted) return;
    Navigator.pop(context); // Close loading

    if (url != null) {
      final success = await provider.updateProfile(
        name: provider.currentUser!.name,
        phone: provider.currentUser!.phone,
        photoUrl: url,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diperbarui')),
        );
      }
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(profileProvider);
    final user = provider.currentUser;

    if (provider.isLoading || user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            ProfileHeader(
              user: user,
              onEditPhoto: _pickAndUploadPhoto,
            ),

            const SizedBox(height: 16),

            // Account Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akun',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.person,
                    title: 'Edit Profil',
                    subtitle: 'Ubah nama, email, dan nomor telepon',
                    onTap: () => context.push('/profile/edit'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.location_on,
                    title: 'Alamat Saya',
                    subtitle:
                        '${provider.addresses.length} alamat tersimpan',
                    onTap: () => context.push('/profile/addresses'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.lock,
                    title: 'Keamanan',
                    subtitle: 'Ubah password dan pengaturan keamanan',
                    onTap: () => context.push('/profile/security'),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Lainnya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan & FAQ',
                    onTap: () {
                      // TODO: Navigate to help
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.description,
                    title: 'Syarat & Ketentuan',
                    onTap: () {
                      // TODO: Navigate to terms
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.privacy_tip,
                    title: 'Kebijakan Privasi',
                    onTap: () {
                      // TODO: Navigate to privacy
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    subtitle: 'Versi 1.0.0',
                    onTap: () {
                      // TODO: Navigate to about
                    },
                  ),

                  const SizedBox(height: 24),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Keluar',
                    onTap: _showLogoutConfirmation,
                    iconColor: Colors.red,
                  ),
                  const SizedBox(height: 80), // Bottom nav space
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
