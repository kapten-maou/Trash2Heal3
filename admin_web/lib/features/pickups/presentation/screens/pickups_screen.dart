import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

import '../../providers/pickups_provider.dart';

class PickupsScreen extends ConsumerStatefulWidget {
  const PickupsScreen({super.key});

  @override
  ConsumerState<PickupsScreen> createState() => _PickupsScreenState();
}

class _PickupsScreenState extends ConsumerState<PickupsScreen> {
  PickupRequestModel? _selected;
  DateTimeRange? _dateRange;
  String _zoneFilter = '';
  String _courierFilter = '';
  int _rowsPerPage = 10;
  int _page = 0;
  String? _sortField;
  bool _ascending = true;

  void _openDetail(PickupRequestModel pickup) {
    setState(() {
      _selected = pickup;
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _DetailDrawer(
        pickup: pickup,
      ),
    );
  }

  void _openFilterPanel() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _FilterDialog(
        initialDateRange: _dateRange,
        initialZone: _zoneFilter,
        initialCourier: _courierFilter,
        onApply: (range, zone) {
          setState(() {
            _dateRange = range;
            _zoneFilter = zone;
            _page = 0;
          });
        },
        onReset: () {
          setState(() {
            _dateRange = null;
            _zoneFilter = '';
            _courierFilter = '';
            _page = 0;
          });
        },
      ),
    );
  }

  void _handleSort(String field) {
    setState(() {
      if (_sortField == field) {
        _ascending = !_ascending;
      } else {
        _sortField = field;
        _ascending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pickupsAsync = ref.watch(pickupsStreamProvider);
    final statusFilter = ref.watch(pickupStatusFilterProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            statusFilter: statusFilter,
            onStatusSelected: (value) =>
                ref.read(pickupStatusFilterProvider.notifier).state = value,
            onSearchChanged: (value) =>
                ref.read(pickupSearchProvider.notifier).state = value,
          ),
          const SizedBox(height: 12),
          _Toolbar(onOpenFilter: _openFilterPanel),
          const SizedBox(height: 16),
          Expanded(
            child: pickupsAsync.when(
              data: (pickups) {
                var list = pickups;

                // Date filter
                if (_dateRange != null) {
                  list = list
                      .where((p) =>
                          p.pickupDate.isAfter(
                              _dateRange!.start.subtract(const Duration(days: 1))) &&
                          p.pickupDate
                              .isBefore(_dateRange!.end.add(const Duration(days: 1))))
                      .toList();
                }
                // Zone filter
                if (_zoneFilter.trim().isNotEmpty) {
                  final z = _zoneFilter.toLowerCase();
                  list = list
                      .where((p) => p.zone.toLowerCase().contains(z))
                      .toList();
                }
                // Courier filter
                if (_courierFilter.trim().isNotEmpty) {
                  final c = _courierFilter.toLowerCase();
                  list = list
                      .where((p) => (p.courierId ?? '').toLowerCase().contains(c))
                      .toList();
                }

                // Sorting
                list.sort((a, b) {
                  int cmp;
                  switch (_sortField) {
                    case 'date':
                      cmp = a.pickupDate.compareTo(b.pickupDate);
                      break;
                    case 'user':
                      cmp = a.userId.compareTo(b.userId);
                      break;
                    case 'status':
                      cmp = a.status.name.compareTo(b.status.name);
                      break;
                    default:
                      cmp = a.id.compareTo(b.id);
                  }
                  return _ascending ? cmp : -cmp;
                });

                final total = list.length;
                final start = _page * _rowsPerPage;
                final end = (start + _rowsPerPage).clamp(0, total);
                final pageItems =
                    (start < total) ? list.sublist(start, end) : <PickupRequestModel>[];

                if (list.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada pickup yang cocok dengan filter.'),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: _PickupsTable(
                        pickups: pageItems,
                        onView: _openDetail,
                        onAssign: (p) => _openDetail(p),
                        onSort: _handleSort,
                        sortField: _sortField,
                        ascending: _ascending,
                      ),
                    ),
                    _PaginationBar(
                      page: _page,
                      rowsPerPage: _rowsPerPage,
                      total: total,
                      onPageChanged: (p) => setState(() => _page = p),
                      onRowsPerPageChanged: (r) => setState(() {
                        _rowsPerPage = r;
                        _page = 0;
                      }),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Gagal memuat data: $e'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? statusFilter;
  final ValueChanged<String?> onStatusSelected;
  final ValueChanged<String> onSearchChanged;

  const _Header({
    required this.statusFilter,
    required this.onStatusSelected,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    const statuses = <String, String>{
      'pending': 'Pending',
      'assigned': 'Assigned',
      'on_the_way': 'On The Way',
      'arrived': 'Arrived',
      'picked_up': 'Picked Up',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Pickups',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Live Firestore',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 260,
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Cari Pickup ID / User / Alamat',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'Semua',
                selected: statusFilter == null,
                onSelected: () => onStatusSelected(null),
              ),
              ...statuses.entries.map(
                (e) => _FilterChip(
                  label: e.value,
                  selected: statusFilter == e.key,
                  onSelected: () => onStatusSelected(e.key),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: Colors.green.shade50,
        labelStyle: TextStyle(
          color: selected ? Colors.green.shade700 : Colors.grey.shade800,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected ? Colors.green.shade300 : Colors.grey.shade300,
        ),
      ),
    );
  }
}

class _PickupsTable extends StatelessWidget {
  final List<PickupRequestModel> pickups;
  final ValueChanged<PickupRequestModel> onView;
  final ValueChanged<PickupRequestModel> onAssign;
  final void Function(String field) onSort;
  final String? sortField;
  final bool ascending;

  const _PickupsTable({
    required this.pickups,
    required this.onView,
    required this.onAssign,
    required this.onSort,
    required this.sortField,
    required this.ascending,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          sortColumnIndex: _sortIndex(),
          sortAscending: ascending,
          columns: [
            DataColumn(
              label: const Text('Pickup ID'),
              onSort: (_, __) => onSort('id'),
            ),
            DataColumn(
              label: const Text('Tanggal & Jam'),
              onSort: (_, __) => onSort('date'),
            ),
            DataColumn(
              label: const Text('User'),
              onSort: (_, __) => onSort('user'),
            ),
            const DataColumn(label: Text('Alamat / Zona')),
            const DataColumn(label: Text('Courier')),
            DataColumn(
              label: const Text('Status'),
              onSort: (_, __) => onSort('status'),
            ),
            const DataColumn(label: Text('Berat / Poin')),
            const DataColumn(label: Text('Actions')),
          ],
          rows: pickups.map((p) => _buildRow(context, p)).toList(),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, PickupRequestModel pickup) {
    final dateText =
        '${pickup.pickupDate.toLocal().toIso8601String().substring(0, 10)} ${pickup.timeRange}';
    final userText = pickup.userId;
    final courierText = pickup.courierId ?? 'Unassigned';
    final address =
        pickup.addressSnapshot['fullAddress']?.toString() ?? 'Alamat';
    final zone = pickup.zone;
    final weightText =
        '${pickup.actualWeight?.toStringAsFixed(1) ?? pickup.estimatedWeight.toStringAsFixed(1)} kg'
        ' / ${pickup.actualPoints ?? pickup.estimatedPoints} pts';

    return DataRow(
      cells: [
        DataCell(Text(pickup.id)),
        DataCell(Text(dateText)),
        DataCell(Text(userText)),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(address, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('Zona $zone',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  )),
            ],
          ),
        ),
        DataCell(Text(courierText)),
        DataCell(_StatusBadge(status: pickup.status)),
        DataCell(Text(weightText)),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () => onView(pickup),
                icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                tooltip: 'Detail',
              ),
              IconButton(
                onPressed: () => onAssign(pickup),
                icon: const Icon(Icons.assignment_ind_outlined, size: 18),
                tooltip: 'Assign courier',
              ),
            ],
          ),
        ),
      ],
    );
  }

  int? _sortIndex() {
    switch (sortField) {
      case 'id':
        return 0;
      case 'date':
        return 1;
      case 'user':
        return 2;
      case 'status':
        return 5;
      default:
        return null;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final PickupStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _colorForStatus(status);
    final label = status.name.replaceAll('_', ' ').toUpperCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Color _colorForStatus(PickupStatus status) {
    switch (status) {
      case PickupStatus.pending:
        return Colors.orange;
      case PickupStatus.assigned:
        return Colors.blue;
      case PickupStatus.onTheWay:
        return Colors.purple;
      case PickupStatus.arrived:
        return Colors.cyan;
      case PickupStatus.pickedUp:
        return Colors.deepOrange;
      case PickupStatus.completed:
        return Colors.green;
      case PickupStatus.cancelled:
        return Colors.red;
    }
  }
}

class _PaginationBar extends StatelessWidget {
  final int page;
  final int rowsPerPage;
  final int total;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onRowsPerPageChanged;

  const _PaginationBar({
    required this.page,
    required this.rowsPerPage,
    required this.total,
    required this.onPageChanged,
    required this.onRowsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final start = page * rowsPerPage + 1;
    final end = ((page + 1) * rowsPerPage).clamp(0, total);
    final canPrev = page > 0;
    final canNext = end < total;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Text(
            'Menampilkan $start-$end dari $total',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Spacer(),
          DropdownButton<int>(
            value: rowsPerPage,
            items: const [
              DropdownMenuItem(value: 10, child: Text('10')),
              DropdownMenuItem(value: 20, child: Text('20')),
              DropdownMenuItem(value: 50, child: Text('50')),
            ],
            onChanged: (v) {
              if (v != null) onRowsPerPageChanged(v);
            },
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: canPrev ? () => onPageChanged(page - 1) : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: canNext ? () => onPageChanged(page + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _FilterDialog extends ConsumerStatefulWidget {
  final DateTimeRange? initialDateRange;
  final String initialZone;
  final String initialCourier;
  final void Function(DateTimeRange?, String) onApply;
  final VoidCallback onReset;

  const _FilterDialog({
    this.initialDateRange,
    this.initialZone = '',
    this.initialCourier = '',
    required this.onApply,
    required this.onReset,
  });

  @override
  ConsumerState<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<_FilterDialog> {
  late DateTimeRange? _range = widget.initialDateRange;
  late String _zone = widget.initialZone;
  late String _courier = widget.initialCourier;

  @override
  Widget build(BuildContext context) {
    final statusFilter = ref.watch(pickupStatusFilterProvider);
    final statuses = <String, String>{
      'pending': 'Pending',
      'assigned': 'Assigned',
      'on_the_way': 'On The Way',
      'arrived': 'Arrived',
      'picked_up': 'Picked Up',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
    };

    return Dialog(
      insetPadding:
          const EdgeInsets.only(left: 120, right: 24, top: 80, bottom: 80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 380,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    'Filter Pickups',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Semua'),
                    selected: statusFilter == null,
                    onSelected: (_) => ref
                        .read(pickupStatusFilterProvider.notifier)
                        .state = null,
                  ),
                  ...statuses.entries.map(
                    (e) => ChoiceChip(
                      label: Text(e.value),
                      selected: statusFilter == e.key,
                      onSelected: (_) => ref
                          .read(pickupStatusFilterProvider.notifier)
                          .state = e.key,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Tanggal',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                    initialDateRange: _range,
                  );
                  if (picked != null) {
                    setState(() => _range = picked);
                  }
                },
                icon: const Icon(Icons.date_range),
                label: Text(_range == null
                    ? 'Pilih rentang tanggal'
                    : '${_range!.start.toLocal().toIso8601String().substring(0, 10)} - ${_range!.end.toLocal().toIso8601String().substring(0, 10)}'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Zona',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: _zone),
                onChanged: (v) => _zone = v,
                decoration: InputDecoration(
                  hintText: 'Contoh: Zona A',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Courier ID/Nama',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: _courier),
                onChanged: (v) => _courier = v,
                decoration: InputDecoration(
                  hintText: 'Cari courier',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cari (Pickup ID / User / Alamat)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (v) =>
                    ref.read(pickupSearchProvider.notifier).state = v,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  hintText: 'Masukkan kata kunci',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(pickupStatusFilterProvider.notifier).state =
                            null;
                        ref.read(pickupSearchProvider.notifier).state = '';
                        _courier = '';
                        widget.onReset();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(_range, _zone);
                        // Optionally update courier filter in search if needed later
                        Navigator.of(context).pop();
                      },
                      child: const Text('Terapkan'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailDrawer extends StatelessWidget {
  final PickupRequestModel pickup;
  const _DetailDrawer({required this.pickup});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.only(left: 80, right: 24, top: 40, bottom: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 420,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Pickup ${pickup.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  _StatusBadge(status: pickup.status),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _detailRow('User ID', pickup.userId),
              _detailRow('Courier', pickup.courierId ?? 'Unassigned'),
              _detailRow('Zona', pickup.zone),
              _detailRow('Jadwal',
                  '${pickup.pickupDate.toLocal().toIso8601String().substring(0, 10)} • ${pickup.timeRange}'),
              _detailRow(
                  'Alamat',
                  pickup.addressSnapshot['fullAddress']?.toString() ??
                      'Alamat tidak tersedia'),
              _detailRow(
                  'Berat/Poin',
                  '${pickup.actualWeight?.toStringAsFixed(1) ?? pickup.estimatedWeight.toStringAsFixed(1)} kg / '
                  '${pickup.actualPoints ?? pickup.estimatedPoints} pts'),
              const SizedBox(height: 16),
              const Text(
                'Timeline',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              _timelineItem('Created', pickup.createdAt),
              _timelineItem('Assigned', pickup.assignedAt),
              _timelineItem('On the way', pickup.onTheWayAt),
              _timelineItem('Arrived', pickup.arrivedAt),
              _timelineItem('Picked up', pickup.pickedUpAt),
              _timelineItem('Completed', pickup.completedAt),
              const SizedBox(height: 12),
              const Text(
                'Catatan',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                pickup.notes ?? '—',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.assignment_turned_in_outlined),
                      label: const Text('Assign/Update'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Cancel'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(String label, DateTime? time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const Spacer(),
          Text(
            time != null
                ? time.toLocal().toIso8601String().substring(0, 16)
                : '-',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends ConsumerWidget {
  final VoidCallback onOpenFilter;

  const _Toolbar({required this.onOpenFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: onOpenFilter,
          icon: const Icon(Icons.filter_alt_outlined, size: 18),
          label: const Text('Filter lanjutan'),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => ref.invalidate(pickupsStreamProvider),
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Refresh'),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_outlined, size: 18),
          label: const Text('Export CSV'),
        ),
      ],
    );
  }
}
