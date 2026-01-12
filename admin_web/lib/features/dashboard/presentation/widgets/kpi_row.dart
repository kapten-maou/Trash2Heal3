import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'stat_card.dart';

/// Live KPI row sourced from Firestore.
class KpiRow extends StatelessWidget {
  final bool isTablet;
  const KpiRow({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final pickupsToday = _countQuery(
      FirebaseFirestore.instance
          .collection('pickupRequests')
          .where(
            'pickupDate',
            isGreaterThanOrEqualTo:
                DateTime.now().subtract(const Duration(hours: 24)),
          ),
    );

    final couriersActive = _countQuery(
      FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'courier')
          .where('isActive', isEqualTo: true),
    );

    final newRegistrations = _countQuery(
      FirebaseFirestore.instance
          .collection('users')
          .where(
            'createdAt',
            isGreaterThanOrEqualTo:
                DateTime.now().subtract(const Duration(days: 7)),
          ),
    );

    // Points distributed this week is optional; show dash if not available.
    final pointsWeek = FirebaseFirestore.instance
        .collection('pointLedgers')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: DateTime.now().subtract(
            const Duration(days: 7),
          ),
        )
        .get()
        .then((snap) {
      final sum = snap.docs.fold<int>(
          0, (prev, d) => prev + (d.data()['amount'] as int? ?? 0));
      return sum;
    });

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([pickupsToday, couriersActive, newRegistrations, pointsWeek]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return GridView.count(
            crossAxisCount: isTablet ? 2 : 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            children: List.generate(
              4,
              (_) => const _ShimmerCard(),
            ),
          );
        }
        final data = snapshot.data!;
        final pickupsCount = data[0] as int;
        final couriersCount = data[1] as int;
        final newUsers = data[2] as int;
        final points = data[3] as int;

        return GridView.count(
          crossAxisCount: isTablet ? 2 : 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.6,
          children: [
            StatCard(
              title: "Today's Pickups",
              value: '$pickupsCount',
              icon: Icons.inventory_2_outlined,
              color: Colors.orange,
              trend: 0,
              subtitle: 'Live count',
            ),
            StatCard(
              title: 'Active Couriers',
              value: '$couriersCount',
              icon: Icons.local_shipping_outlined,
              color: Colors.green,
              trend: 0,
              subtitle: 'isActive=true',
            ),
            StatCard(
              title: 'Points This Week',
              value: points == 0 ? '—' : points.toString(),
              icon: Icons.star_outline_rounded,
              color: Colors.amber,
              trend: 0,
              subtitle: 'Sum of ledgers',
            ),
            StatCard(
              title: 'New Registrations',
              value: '$newUsers',
              icon: Icons.person_add_alt_1_outlined,
              color: Colors.blue,
              trend: 0,
              subtitle: 'Users & couriers',
            ),
          ],
        );
      },
    );
  }

  Future<int> _countQuery(Query query) async {
    final snap = await query.get();
    return snap.size;
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 24, height: 24),
                _box(width: 44, height: 14),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 70, height: 18),
                const SizedBox(height: 4),
                _box(width: 110, height: 12),
                const SizedBox(height: 4),
                _box(width: 90, height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
