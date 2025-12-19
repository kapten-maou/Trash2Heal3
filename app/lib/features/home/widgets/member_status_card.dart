import 'package:flutter/material.dart';

/// Member status card to show active tier and expiry
class MemberStatusCard extends StatelessWidget {
  final String tier; // silver, gold, platinum
  final DateTime? expiryDate;
  final VoidCallback? onExtend;

  const MemberStatusCard({
    super.key,
    required this.tier,
    this.expiryDate,
    this.onExtend,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = _gradientForTier();
    final icon = _iconForTier();
    final tierLabel = tier.isNotEmpty ? tier[0].toUpperCase() + tier.substring(1) : 'Member';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Member $tierLabel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (expiryDate != null)
                  Text(
                    'Aktif hingga ${_formatDate(expiryDate!)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onExtend,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text(
              'Perpanjang',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _gradientForTier() {
    switch (tier.toLowerCase()) {
      case 'gold':
        return const LinearGradient(
          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'platinum':
        return const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF9CA3AF), Color(0xFF6B7280)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  String _iconForTier() {
    switch (tier.toLowerCase()) {
      case 'gold':
        return '👑';
      case 'platinum':
        return '🏆';
      default:
        return '⭐';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
