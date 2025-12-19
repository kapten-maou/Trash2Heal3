import 'package:flutter/material.dart';

/// Category card with increment/decrement counter
class CategoryCounterCard extends StatelessWidget {
  final String categoryId;
  final String name;
  final String icon;
  final double value;
  final ValueChanged<double> onChanged;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CategoryCounterCard({
    super.key,
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value > 0
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : const Color(0xFFE5E7EB),
          width: value > 0 ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Icon and name
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),

          // Counter
          _buildCounter(context),
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrement button
        _buildCounterButton(
          context: context,
          icon: Icons.remove,
          onPressed: value > 0 ? onDecrement : null,
        ),
        const SizedBox(width: 12),

        // Value display
        Container(
          constraints: const BoxConstraints(minWidth: 60),
          child: Text(
            '${value.toStringAsFixed(1)} kg',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: value > 0
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF6B7280),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Increment button
        _buildCounterButton(
          context: context,
          icon: Icons.add,
          onPressed: onIncrement,
        ),
      ],
    );
  }

  Widget _buildCounterButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Material(
      color:
          onPressed != null ? const Color(0xFFF3F4F6) : const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: onPressed != null
                ? const Color(0xFF374151)
                : const Color(0xFFD1D5DB),
          ),
        ),
      ),
    );
  }
}
