import 'package:flutter/material.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

/// Status progress indicator for task detail
class StatusProgress extends StatelessWidget {
  final PickupStatus currentStatus;

  const StatusProgress({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'status': PickupStatus.assigned, 'label': 'Assigned'},
      {'status': PickupStatus.onTheWay, 'label': 'On the Way'},
      {'status': PickupStatus.arrived, 'label': 'Arrived'},
      {'status': PickupStatus.pickedUp, 'label': 'Picked Up'},
      {'status': PickupStatus.completed, 'label': 'Completed'},
    ];

    final currentIndex =
        steps.indexWhere((s) => s['status'] == currentStatus);
    final activeIndex = currentIndex >= 0 ? currentIndex : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STATUS PROGRES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B7280),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                final step = steps[stepIndex];
                final isCompleted = stepIndex < activeIndex;
                final isCurrent = stepIndex == activeIndex;

                return _buildStep(
                  context: context,
                  label: step['label'] as String,
                  isCompleted: isCompleted,
                  isCurrent: isCurrent,
                );
              } else {
                final beforeIndex = index ~/ 2;
                final isCompleted = beforeIndex < activeIndex;
                return _buildLine(context, isCompleted);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required BuildContext context,
    required String label,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    Color color;
    if (isCompleted) {
      color = Theme.of(context).colorScheme.primary;
    } else if (isCurrent) {
      color = Theme.of(context).colorScheme.primary;
    } else {
      color = const Color(0xFFD1D5DB);
    }

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isCurrent ? color : Colors.transparent,
              border: Border.all(
                color: color,
                width: isCompleted || isCurrent ? 0 : 2,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : isCurrent
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
              color: isCompleted || isCurrent
                  ? const Color(0xFF111827)
                  : const Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLine(BuildContext context, bool isCompleted) {
    return Container(
      height: 2,
      width: 24,
      margin: const EdgeInsets.only(bottom: 28),
      color: isCompleted
          ? Theme.of(context).colorScheme.primary
          : const Color(0xFFD1D5DB),
    );
  }
}
