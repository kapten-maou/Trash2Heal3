import 'package:flutter/material.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

/// Task card for courier task list
class TaskCard extends StatelessWidget {
  final PickupRequestModel task;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(task.status);
    final statusLabel = _getStatusLabel(task.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: statusColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Status badge + Task ID
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '#${task.id.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Customer name
                Text(
                  task.address['recipientName'] ?? 'Customer',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),

                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.address['fullAddress'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${task.address['city'] ?? ''} • Zona ${task.zone}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Time slot
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.timeRange,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Estimated weight
                Row(
                  children: [
                    const Icon(
                      Icons.scale,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '~${task.estimatedWeight.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action button
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'LIHAT DETAIL',
                      style: TextStyle(
                        fontSize: 12,
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
      ),
    );
  }

  Color _getStatusColor(PickupStatus status) {
    switch (status) {
      case PickupStatus.pending:
        return const Color(0xFF9CA3AF);
      case PickupStatus.assigned:
        return const Color(0xFF10B981);
      case PickupStatus.onTheWay:
        return const Color(0xFFF59E0B);
      case PickupStatus.arrived:
        return const Color(0xFF3B82F6);
      case PickupStatus.pickedUp:
        return const Color(0xFFFF9800);
      case PickupStatus.completed:
        return const Color(0xFF6B7280);
      case PickupStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }

  String _getStatusLabel(PickupStatus status) {
    switch (status) {
      case PickupStatus.pending:
        return '⌛ PENDING';
      case PickupStatus.assigned:
        return '🟢 ASSIGNED';
      case PickupStatus.onTheWay:
        return '🟡 ON THE WAY';
      case PickupStatus.arrived:
        return '🔵 ARRIVED';
      case PickupStatus.pickedUp:
        return '🟠 PICKED UP';
      case PickupStatus.completed:
        return '⚪ COMPLETED';
      case PickupStatus.cancelled:
        return '🔴 CANCELLED';
    }
  }
}
