// ========== address_card.dart ==========

import 'package:flutter/material.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSetPrimary;

  const AddressCard({
    super.key,
    required this.address,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      address.label,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (address.isPrimary) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, size: 12, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            'Utama',
                            style: TextStyle(fontSize: 12, color: Colors.amber),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    itemBuilder: (context) => [
                      if (!address.isPrimary && onSetPrimary != null)
                        const PopupMenuItem(
                          value: 'primary',
                          child: Row(
                            children: [
                              Icon(Icons.star, size: 18),
                              SizedBox(width: 8),
                              Text('Jadikan Utama'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'primary') onSetPrimary?.call();
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                address.recipientName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address.phone,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                address.fullAddress,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 4),
              Text(
                '${address.city}, ${address.postalCode}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
