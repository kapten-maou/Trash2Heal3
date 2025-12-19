import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/address_card.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileProvider).loadAddresses();
    });
  }

  void _confirmDelete(String addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Alamat'),
        content: const Text('Apakah Anda yakin ingin menghapus alamat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success =
                  await ref.read(profileProvider).deleteAddress(addressId);
              if (mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alamat berhasil dihapus')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _setPrimaryAddress(String addressId) async {
    final success =
        await ref.read(profileProvider).setPrimaryAddress(addressId);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat utama berhasil diubah')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(profileProvider);
    final addresses = provider.addresses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Saya'),
        elevation: 0,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off,
                          size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada alamat tersimpan',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tambahkan alamat untuk memudahkan\npenjemputan sampah',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return AddressCard(
                      address: address,
                      onTap: () {
                        // View details
                      },
                      onEdit: () {
                        context.push('/profile/addresses/edit/${address.id}');
                      },
                      onDelete: () => _confirmDelete(address.id),
                      onSetPrimary: () => _setPrimaryAddress(address.id),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/profile/addresses/add'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Alamat'),
        heroTag: 'add_address',
      ),
    );
  }
}
