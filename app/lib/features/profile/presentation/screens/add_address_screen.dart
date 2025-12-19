import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../providers/profile_provider.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/primary_button.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  final String? addressId; // For editing

  const AddAddressScreen({super.key, this.addressId});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();
  bool _isPrimary = false;
  bool _isLoading = false;

  String _selectedLabel = 'Rumah';
  final List<String> _labels = [
    'Rumah',
    'Kantor',
    'Apartemen',
    'Kos',
    'Lainnya'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.addressId != null) {
      _loadAddress();
    }
  }

  void _loadAddress() {
    final addresses = ref.read(profileProvider).addresses;
    final address = addresses.firstWhere((a) => a.id == widget.addressId);

    _selectedLabel = address.label;
    _nameController.text = address.recipientName;
    _phoneController.text = address.phone;
    _addressController.text = address.fullAddress;
    _cityController.text = address.city;
    _postalController.text = address.postalCode;
    _isPrimary = address.isPrimary;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus login untuk menambahkan alamat'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final address = AddressModel(
      id: widget.addressId ?? '',
      userId: uid,
      label:
          _selectedLabel == 'Lainnya' ? _labelController.text : _selectedLabel,
      recipientName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      fullAddress: _addressController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalController.text.trim(),
      isPrimary: _isPrimary,
      createdAt: DateTime.now(),
    );

    bool success;
    if (widget.addressId != null) {
      success = await ref.read(profileProvider).updateAddress(address);
    } else {
      success = await ref.read(profileProvider).addAddress(address);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.addressId != null
              ? 'Alamat berhasil diperbarui'
              : 'Alamat berhasil ditambahkan'),
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(ref.read(profileProvider).error ?? 'Gagal menyimpan alamat'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.addressId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Alamat' : 'Tambah Alamat'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Label Selection
              Text(
                'Label Alamat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _labels.map((label) {
                  final isSelected = _selectedLabel == label;
                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedLabel = label);
                    },
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),

              if (_selectedLabel == 'Lainnya') ...[
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _labelController,
                  label: 'Nama Label',
                  prefixIcon: Icon(Icons.label),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Label tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 24),

              // Recipient Name
              CustomTextField(
                controller: _nameController,
                label: 'Nama Penerima',
                prefixIcon: Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama penerima tidak boleh kosong';
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
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Full Address
              CustomTextField(
                controller: _addressController,
                label: 'Alamat Lengkap',
                prefixIcon: Icon(Icons.location_on),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // City
              CustomTextField(
                controller: _cityController,
                label: 'Kota/Kabupaten',
                prefixIcon: Icon(Icons.location_city),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kota tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Postal Code
              CustomTextField(
                controller: _postalController,
                label: 'Kode Pos',
                prefixIcon: Icon(Icons.markunread_mailbox),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode pos tidak boleh kosong';
                  }
                  if (value.length != 5) {
                    return 'Kode pos harus 5 digit';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Set as Primary
              CheckboxListTile(
                value: _isPrimary,
                onChanged: (value) =>
                    setState(() => _isPrimary = value ?? false),
                title: const Text('Jadikan alamat utama'),
                subtitle: const Text('Alamat ini akan dipilih secara default'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 32),

              // Save Button
              PrimaryButton(
                text: isEdit ? 'Simpan Perubahan' : 'Tambah Alamat',
                isLoading: _isLoading,
                onPressed: _saveAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
