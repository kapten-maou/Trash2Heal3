// ========== quick_actions_row.dart (UPDATED) ==========
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          context,
          icon: Icons.calendar_today,
          label: 'Pickup',
          onTap: () => context.push('/pickup/quantity'),
        ),
        _buildActionButton(
          context,
          icon: Icons.celebration,
          label: 'Event',
          onTap: () => context.push('/events'),
        ),
        _buildActionButton(
          context,
          icon: Icons.receipt_long,
          label: 'Riwayat',
          onTap: () => context.push('/history'),
        ),
        _buildActionButton(
          context,
          icon: Icons.chat_bubble_outline,
          label: 'Chat',
          onTap: () => context.push('/chat'),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFFCF4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.green.shade600, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
