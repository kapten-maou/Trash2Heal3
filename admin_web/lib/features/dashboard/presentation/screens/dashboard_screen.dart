import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import '../widgets/kpi_row.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width < 1200;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AlertsBanner(),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Live overview',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          KpiRow(isTablet: isTablet),
          const SizedBox(height: 24),
          Flex(
            direction: isTablet ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _TrendsCard()),
              SizedBox(width: isTablet ? 0 : 16, height: isTablet ? 16 : 0),
              Expanded(flex: 1, child: _DistributionCard()),
            ],
          ),
          const SizedBox(height: 24),
          Flex(
            direction: isTablet ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _OverviewCard(
                  title: 'Active Users',
                  actionLabel: 'View all',
                  onAction: () => context.go('/admin/users'),
                  rows: const [
                    _OverviewRow(
                        title: 'John Doe',
                        subtitle: 'Gold Member',
                        meta: 'Joined 2d ago'),
                    _OverviewRow(
                        title: 'Jane Smith',
                        subtitle: 'Free',
                        meta: 'Joined 3d ago'),
                    _OverviewRow(
                        title: 'Budi Santoso',
                        subtitle: 'Platinum',
                        meta: 'Joined 5d ago'),
                  ],
                ),
              ),
              SizedBox(width: isTablet ? 0 : 16, height: isTablet ? 16 : 0),
              Expanded(
                child: _OverviewCard(
                  title: 'Courier Performance',
                  actionLabel: 'View all',
                  onAction: () => context.go('/admin/couriers'),
                  rows: const [
                    _OverviewRow(
                        title: 'Andi Pratama',
                        subtitle: 'Zone A • 12 pickups',
                        meta: '⭐ 4.9'),
                    _OverviewRow(
                        title: 'Siti Rahma',
                        subtitle: 'Zone B • 10 pickups',
                        meta: '⭐ 4.8'),
                    _OverviewRow(
                        title: 'Rudi Hartono',
                        subtitle: 'Zone C • 9 pickups',
                        meta: '⭐ 4.7'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _ActivityFeed(),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;
  final Widget child;
  const _ChartCard(
      {required this.title,
      required this.subtitle,
      required this.height,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(height: height, child: child),
          ],
        ),
      ),
    );
  }
}

class _TrendsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_TrendPoint>>(
      future: _fetchPickupTrends(days: 7),
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        final maxVal = data.isNotEmpty
            ? data.map((e) => e.count).reduce(math.max)
            : 1;
        return _ChartCard(
          title: 'Pickup Trends',
          subtitle: '7 hari terakhir',
          height: 260,
          child: snapshot.connectionState == ConnectionState.waiting
              ? const _PlaceholderChart(label: 'Loading...')
              : data.isEmpty
                  ? const Center(child: Text('Tidak ada data'))
                  : Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: data
                            .map(
                              (p) => Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('${p.count}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 4),
                                      Container(
                                        height: 140 *
                                            (p.count /
                                                maxVal
                                                    .clamp(1, double.infinity)),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(p.label,
                                          style: const TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
        );
      },
    );
  }
}

class _DistributionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_DistributionSlice>>(
      future: _fetchDistribution(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        final total = data.fold<int>(0, (prev, e) => prev + e.weight);
        return _ChartCard(
          title: 'Waste Distribution',
          subtitle: '7 hari terakhir',
          height: 260,
          child: snapshot.connectionState == ConnectionState.waiting
              ? const _PlaceholderChart(label: 'Loading...')
              : data.isEmpty
                  ? const Center(child: Text('Tidak ada data'))
                  : Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: _buildSections(data, total),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: data
                                .map((e) => _LegendChip(
                                      label:
                                          '${e.category} • ${e.weight} kg (${((e.weight / total) * 100).toStringAsFixed(1)}%)',
                                      color: _colorForCategory(e.category),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildSections(
      List<_DistributionSlice> data, int total) {
    final sections = <PieChartSectionData>[];
    for (final slice in data) {
      final percent =
          total == 0 ? 0.0 : (slice.weight / total.toDouble()) * 100;
      sections.add(
        PieChartSectionData(
          color: _colorForCategory(slice.category),
          value: percent,
          title: '${percent.toStringAsFixed(1)}%',
          radius: 70,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    }
    return sections;
  }

  Color _colorForCategory(String category) {
    final key = category.toLowerCase();
    if (key.contains('plast')) return const Color(0xFF3F51B5);
    if (key.contains('kaca') || key.contains('glass')) {
      return const Color(0xFF00BCD4);
    }
    if (key.contains('kaleng') || key.contains('can')) {
      return const Color(0xFF9E9E9E);
    }
    if (key.contains('kardus') || key.contains('cardboard')) {
      return const Color(0xFF795548);
    }
    if (key.contains('organik') || key.contains('organic')) {
      return const Color(0xFF2E7D32);
    }
    return Colors.green.shade300;
  }
}

class _PlaceholderChart extends StatelessWidget {
  final String label;
  const _PlaceholderChart({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  final List<_OverviewRow> rows;

  const _OverviewCard({
    required this.title,
    required this.actionLabel,
    required this.onAction,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: onAction, child: Text(actionLabel)),
              ],
            ),
            const SizedBox(height: 8),
            ...rows.expand((r) => [
                  r,
                  if (r != rows.last) const Divider(height: 24),
                ]),
          ],
        ),
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String meta;

  const _OverviewRow({
    required this.title,
    required this.subtitle,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.green.shade50,
          child: Text(
            title.isNotEmpty ? title[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Text(
          meta,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _ActivityFeed extends StatelessWidget {
  const _ActivityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('activityLogs')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: navigate to activity log
                  },
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator(minHeight: 2);
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const Text(
                    'Gagal memuat activity.',
                    style: TextStyle(fontSize: 12, color: Colors.redAccent),
                  );
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Text(
                    'Belum ada aktivitas.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  );
                }
                final items = docs.map((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final title = data['title']?.toString() ?? 'Activity';
                  final desc = data['description']?.toString() ?? '';
                  final status =
                      data['type']?.toString()?.toUpperCase() ?? 'INFO';
                  final ts = data['timestamp'];
                  String timeLabel = '';
                  if (ts is Timestamp) {
                    timeLabel =
                        ts.toDate().toLocal().toIso8601String().substring(0, 16);
                  }
                  return _ActivityRow(
                    title: title,
                    desc: desc,
                    time: timeLabel,
                    status: status,
                  );
                }).toList();

                return Column(
                  children: items.expand((item) => [
                        item,
                        if (item != items.last) const Divider(),
                      ]).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String title;
  final String desc;
  final String time;
  final String status;

  const _ActivityRow({
    required this.title,
    required this.desc,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bolt, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _statusBadge(status),
                    const SizedBox(width: 12),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'COMPLETED':
        color = Colors.green;
        break;
      case 'ASSIGNED':
        color = Colors.blue;
        break;
      case 'SUCCESS':
        color = Colors.teal;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _AlertsBanner extends StatefulWidget {
  const _AlertsBanner();

  @override
  State<_AlertsBanner> createState() => _AlertsBannerState();
}

class _AlertsBannerState extends State<_AlertsBanner> {
  final Set<String> _dismissed = {};

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('adminAlerts')
        .orderBy('createdAt', descending: true)
        .limit(3)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        final docs =
            snapshot.data!.docs.where((d) => !_dismissed.contains(d.id)).toList();
        if (docs.isEmpty) return const SizedBox.shrink();

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final title = data['title']?.toString() ?? 'System Alert';
            final message = data['message']?.toString() ?? '';
            final level = (data['level']?.toString() ?? 'warning').toLowerCase();
            Color bg;
            Color iconColor;
            IconData icon;
            switch (level) {
              case 'error':
                bg = Colors.red.shade50;
                iconColor = Colors.red.shade700;
                icon = Icons.error_outline;
                break;
              case 'info':
                bg = Colors.blue.shade50;
                iconColor = Colors.blue.shade700;
                icon = Icons.info_outline;
                break;
              default:
                bg = Colors.orange.shade50;
                iconColor = Colors.orange.shade700;
                icon = Icons.warning_amber_outlined;
            }

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: iconColor,
                          ),
                        ),
                        if (message.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              message,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      setState(() {
                        _dismissed.add(doc.id);
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _TrendPoint {
  final String label;
  final int count;
  _TrendPoint({required this.label, required this.count});
}

Future<List<_TrendPoint>> _fetchPickupTrends({int days = 7}) async {
  final now = DateTime.now();
  final start =
      DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));
  final snap = await FirebaseFirestore.instance
      .collection('pickupRequests')
      .where('pickupDate', isGreaterThanOrEqualTo: start)
      .get();

  final buckets = <String, int>{};
  for (var i = 0; i < days; i++) {
    final day = start.add(Duration(days: i));
    final key = '${day.month}/${day.day}';
    buckets[key] = 0;
  }

  for (final doc in snap.docs) {
    final data = doc.data();
    final ts = data['pickupDate'];
    DateTime? dt;
    if (ts is Timestamp) {
      dt = ts.toDate();
    } else if (ts is String) {
      dt = DateTime.tryParse(ts);
    }
    if (dt != null && dt.isAfter(start.subtract(const Duration(seconds: 1)))) {
      final key = '${dt.month}/${dt.day}';
      if (buckets.containsKey(key)) {
        buckets[key] = (buckets[key] ?? 0) + 1;
      }
    }
  }

  return buckets.entries
      .map((e) => _TrendPoint(label: e.key, count: e.value))
      .toList();
}

class _DistributionSlice {
  final String category;
  final int weight;
  _DistributionSlice({required this.category, required this.weight});
}

Future<List<_DistributionSlice>> _fetchDistribution() async {
  final now = DateTime.now();
  final start =
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
  final snap = await FirebaseFirestore.instance
      .collection('pickupRequests')
      .where('pickupDate', isGreaterThanOrEqualTo: start)
      .get();

  final totals = <String, int>{};
  for (final doc in snap.docs) {
    final data = doc.data();
    final quantities =
        (data['quantities'] as Map?)?.cast<String, dynamic>() ?? {};
    quantities.forEach((cat, qty) {
      final intVal = (qty is int)
          ? qty
          : (qty is num)
              ? qty.toInt()
              : 0;
      totals[cat] = (totals[cat] ?? 0) + intVal;
    });
  }

  return totals.entries
      .map((e) => _DistributionSlice(category: e.key, weight: e.value))
      .toList();
}
