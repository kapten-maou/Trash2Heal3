import 'package:flutter/material.dart';

/// Stepper indicator for pickup flow
/// ●━━●━━○━━○ (1/4)
class StepperIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const StepperIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
    this.stepLabels = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dots and lines
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isEven) {
              // Dot
              final stepNumber = (index ~/ 2) + 1;
              return _buildDot(context, stepNumber);
            } else {
              // Line
              return _buildLine(context, (index ~/ 2) + 1);
            }
          }),
        ),
        const SizedBox(height: 8),
        // Step counter
        Text(
          '($currentStep/$totalSteps)',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDot(BuildContext context, int stepNumber) {
    final isCompleted = stepNumber < currentStep;
    final isCurrent = stepNumber == currentStep;
    final isUpcoming = stepNumber > currentStep;

    Color color;
    if (isCompleted) {
      color = Theme.of(context).colorScheme.primary;
    } else if (isCurrent) {
      color = Theme.of(context).colorScheme.primary;
    } else {
      color = const Color(0xFFD1D5DB);
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isCurrent ? color : Colors.transparent,
        border: Border.all(
          color: color,
          width: isCompleted || isCurrent ? 0 : 2,
        ),
      ),
      child: isCompleted
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 12,
            )
          : isCurrent
              ? Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
    );
  }

  Widget _buildLine(BuildContext context, int beforeStep) {
    final isCompleted = beforeStep < currentStep;

    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted
            ? Theme.of(context).colorScheme.primary
            : const Color(0xFFD1D5DB),
      ),
    );
  }
}
