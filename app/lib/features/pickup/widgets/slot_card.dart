import 'package:flutter/material.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

/// Slot card for pickup scheduling
class SlotCard extends StatelessWidget {
  final PickupSlotModel slot;
  final bool isSelected;
  final VoidCallback? onTap;

  const SlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final available = slot.capacityWeightKg - slot.usedWeightKg;
    final isFull = available <= 0;
    final isLowCapacity = available < 50 && available > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isFull ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : isFull
                        ? const Color(0xFFE5E7EB)
                        : const Color(0xFFE5E7EB),
                width: isSelected ? 2 : 1,
              ),
              color: isFull ? const Color(0xFFF9FAFB) : Colors.white,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isFull
                        ? const Color(0xFFE5E7EB)
                        : isLowCapacity
                            ? const Color(0xFFFEF3C7)
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: isFull
                        ? const Color(0xFF9CA3AF)
                        : isLowCapacity
                            ? const Color(0xFFF59E0B)
                            : Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Slot info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slot.timeRange,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isFull
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: isFull
                                ? const Color(0xFFD1D5DB)
                                : const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Zona ${slot.zone}',
                            style: TextStyle(
                              fontSize: 14,
                              color: isFull
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: TextStyle(
                              color: isFull
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isFull
                                ? 'Penuh'
                                : '${available.toStringAsFixed(0)} kg tersisa',
                            style: TextStyle(
                              fontSize: 14,
                              color: isFull
                                  ? const Color(0xFFEF4444)
                                  : isLowCapacity
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFF10B981),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.inventory_2,
                              size: 14, color: Color(0xFF6B7280)),
                          const SizedBox(width: 6),
                          Text(
                            isFull
                                ? 'Kuota habis'
                                : 'Kuota tersisa: ${available.toStringAsFixed(0)} kg',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Button
                _buildButton(context, isFull, isSelected, isLowCapacity),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, bool isFull, bool isSelected, bool isLowCapacity) {
    if (isFull) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'PENUH',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9CA3AF),
          ),
        ),
      );
    }

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'DIPILIH',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isLowCapacity
              ? const Color(0xFFF59E0B)
              : Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isLowCapacity ? 'SISA SEDIKIT' : 'PILIH',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isLowCapacity
              ? const Color(0xFFF59E0B)
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
