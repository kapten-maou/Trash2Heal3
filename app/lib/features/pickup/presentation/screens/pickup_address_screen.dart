import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../providers/pickup_provider.dart';
import '../../widgets/stepper_indicator.dart';
import '../../widgets/selectable_address_card.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/secondary_button.dart';
import '../../../auth/providers/auth_provider.dart';

class PickupAddressScreen extends ConsumerStatefulWidget {
  const PickupAddressScreen({super.key});

  @override
  ConsumerState<PickupAddressScreen> createState() =>
      _PickupAddressScreenState();
}

class _PickupAddressScreenState extends ConsumerState<PickupAddressScreen> {
  List<AddressModel> _addresses = [];
  bool _isLoading = true;
  final AddressRepository _addressRepository = AddressRepository();
  final _addFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final authState = ref.read(authProvider);
    if (authState.user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final addresses =
          await _addressRepository.getByUserId(authState.user!.uid);

      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickupState = ref.watch(pickupProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(pickupProvider.notifier).previousStep();
            context.pop();
          },
        ),
        title: const Text(
          'PICKUP',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: const StepperIndicator(currentStep: 2, totalSteps: 4),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pilih Alamat Penjemputan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_addresses.isEmpty)
                          _buildEmptyState()
                        else
                          ..._addresses.map((address) {
                            return SelectableAddressCard(
                              address: address,
                              isSelected:
                                  pickupState.selectedAddress?.id == address.id,
                              onTap: () {
                                ref
                                    .read(pickupProvider.notifier)
                                    .selectAddress(address);
                              },
                            );
                          }).toList(),
                        SecondaryButton(
                          text: '+ Tambah Alamat Baru',
                          onPressed: _showAddAddressBottomSheet,
                          isFullWidth: true,
                          icon: Icons.add_location_alt,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: PrimaryButton(
                text: 'LANJUT',
                onPressed: pickupState.canProceedFromStep2
                    ? () {
                        ref.read(pickupProvider.notifier).nextStep();
                        context.push('/pickup/schedule');
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: const [
            Icon(Icons.location_off, size: 64, color: Color(0xFFD1D5DB)),
            SizedBox(height: 16),
            Text(
              'Belum ada alamat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tambahkan alamat terlebih dahulu',
              style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog() {
    // Deprecated method, kept for compatibility. Redirect to bottom sheet.
    _showAddAddressBottomSheet();
  }

  void _showAddAddressBottomSheet() {
    final labelController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final postalController = TextEditingController();
    String selectedLabel = 'Rumah';
    bool isPrimary = _addresses.isEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Form(
            key: _addFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tambah Alamat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Label Alamat',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Rumah', 'Kantor', 'Apartemen', 'Kos', 'Lainnya']
                        .map((label) {
                      final isSelected = selectedLabel == label;
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedLabel = label;
                          });
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  if (selectedLabel == 'Lainnya') ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: labelController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Label',
                        prefixIcon: Icon(Icons.label),
                      ),
                      validator: (value) {
                        if (selectedLabel == 'Lainnya' &&
                            (value == null || value.isEmpty)) {
                          return 'Label tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Penerima',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 3) {
                        return 'Minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon wajib diisi';
                      }
                      if (!RegExp(r'^(\+62|0)\d{9,12}$').hasMatch(value)) {
                        return 'Format nomor tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Lengkap',
                      prefixIcon: Icon(Icons.home),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Alamat wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'Kota',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kota wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: postalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Kode Pos',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 5) {
                        return 'Kode pos tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Jadikan alamat utama'),
                    value: isPrimary,
                    onChanged: (val) {
                      setState(() {
                        isPrimary = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_addFormKey.currentState!.validate()) return;

                        final authState = ref.read(authProvider);
                        if (authState.user == null) return;

                        final newAddress = AddressModel(
                          id: '',
                          userId: authState.user!.uid,
                          label: selectedLabel == 'Lainnya'
                              ? labelController.text.trim()
                              : selectedLabel,
                          recipientName: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          fullAddress: addressController.text.trim(),
                          city: cityController.text.trim(),
                          postalCode: postalController.text.trim(),
                          isPrimary: isPrimary,
                          createdAt: DateTime.now(),
                        );

                        try {
                          final newId =
                              await _addressRepository.create(newAddress);

                          // Set primary jika dipilih
                          if (isPrimary) {
                            await _addressRepository.setPrimaryAddress(
                              authState.user!.uid,
                              newId,
                            );
                          }

                          await _loadAddresses();

                          // pilih alamat baru langsung
                          final created = _addresses
                              .firstWhere((addr) => addr.id == newId);
                          ref
                              .read(pickupProvider.notifier)
                              .selectAddress(created);

                          if (mounted) Navigator.pop(ctx);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Alamat berhasil ditambahkan')),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Gagal menambahkan alamat: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'SIMPAN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
