import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/profile_provider.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/primary_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(profileProvider).currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref.read(profileProvider).updateProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          photoUrl: ref.read(profileProvider).currentUser?.photoUrl,
        );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              ref.read(profileProvider).error ?? 'Gagal memperbarui profil'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : null,
                            child: user.photoUrl == null
                                ? Text(
                                    user.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 48,
                                      color: Colors.green,
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Name
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        if (value.length < 3) {
                          return 'Nama minimal 3 karakter';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Phone
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Nomor Telepon',
                      prefixIcon: Icon(Icons.phone),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor telepon tidak boleh kosong';
                        }
                        if (!RegExp(r'^[0-9+]+$').hasMatch(value)) {
                          return 'Nomor telepon tidak valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Email (read-only)
                    CustomTextField(
                      controller: TextEditingController(text: user.email),
                      label: 'Email',
                      prefixIcon: Icon(Icons.email),
                      readOnly: true,
                      hintText: 'Email tidak dapat diubah',
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    PrimaryButton(
                      text: 'Simpan Perubahan',
                      isLoading: _isLoading,
                      onPressed: _saveProfile,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
