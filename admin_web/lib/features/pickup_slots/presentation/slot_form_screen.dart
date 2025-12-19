// ============================================================
// FILE: admin_web/lib/features/pickup_slots/presentation/slot_form_screen.dart
// DESCRIPTION: Add/Edit form for pickup slots
// FEATURES:
// - Date picker for slot date
// - Time pickers for start and end time
// - Capacity input field
// - Active status toggle
// - Form validation
// - Create/Update functionality
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../../core/theme/admin_theme.dart';
import '../providers/pickup_slots_provider.dart';

class SlotFormScreen extends ConsumerStatefulWidget {
  final String? slotId;

  const SlotFormScreen({super.key, this.slotId});

  @override
  ConsumerState<SlotFormScreen> createState() => _SlotFormScreenState();
}

class _SlotFormScreenState extends ConsumerState<SlotFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _capacityController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _zone = 'A';
  bool _isActive = true;
  bool _isLoading = false;

  bool get isEdit => widget.slotId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadSlotData();
      });
    }
  }

  void _loadSlotData() {
    final slot = ref.read(pickupSlotsProvider).selectedSlot;
    if (slot == null) return;

    _selectedDate = slot.date;
    final times = slot.timeRange.split('-').map((s) => s.trim()).toList();
    if (times.length == 2) {
      final startParts = times[0].split(':');
      final endParts = times[1].split(':');
      if (startParts.length == 2 && endParts.length == 2) {
        _startTime = TimeOfDay(
            hour: int.tryParse(startParts[0]) ?? 9,
            minute: int.tryParse(startParts[1]) ?? 0);
        _endTime = TimeOfDay(
            hour: int.tryParse(endParts[0]) ?? 10,
            minute: int.tryParse(endParts[1]) ?? 0);
      }
    }
    _capacityController.text = slot.capacityWeightKg.toString();
    _isActive = slot.isActive;
    _zone = slot.zone;
  }

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          backgroundColor: AdminTheme.errorColor,
        ),
      );
      return;
    }

    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end time'),
          backgroundColor: AdminTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final timeRange =
        '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')} - ${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';
    final capacity = int.parse(_capacityController.text);

    final normalizedDate =
        DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);

    final slot = PickupSlotModel(
      id: widget.slotId ?? '',
      date: normalizedDate,
      timeRange: timeRange,
      zone: _zone,
      capacityWeightKg: capacity,
      usedWeightKg: isEdit ? (ref.read(pickupSlotsProvider).selectedSlot?.usedWeightKg ?? 0) : 0,
      isActive: _isActive,
      createdAt: DateTime.now(),
    );

    bool ok = false;
    if (isEdit && widget.slotId != null) {
      ok = await ref
          .read(pickupSlotsProvider.notifier)
          .updateSlot(widget.slotId!, slot);
    } else {
      ok = await ref.read(pickupSlotsProvider.notifier).createSlot(slot);
    }

    if (mounted) {
      setState(() => _isLoading = false);

      final state = ref.read(pickupSlotsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok
              ? (isEdit ? 'Slot updated!' : 'Slot created!')
              : (state.error ?? 'Gagal menyimpan slot')),
          backgroundColor: ok ? AdminTheme.successColor : AdminTheme.errorColor,
        ),
      );

      if (ok) {
        context.go('/admin/pickup-slots');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final slotsState = ref.watch(pickupSlotsProvider);
    if (isEdit &&
        widget.slotId != null &&
        slotsState.selectedSlot == null &&
        !slotsState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(pickupSlotsProvider.notifier).loadSlotById(widget.slotId!);
      });
    }

    if (isEdit && slotsState.selectedSlot != null && _selectedDate == null) {
      _loadSlotData();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1200,
              minHeight: constraints.maxHeight - 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () => context.go('/admin/pickup-slots'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Slots'),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            isEdit ? 'Edit Pickup Slot' : 'Add New Pickup Slot',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),
                          ListTile(
                            title: const Text('Date'),
                            subtitle: Text(
                              _selectedDate != null
                                  ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                                  : 'Select date',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 180)),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                            tileColor: AdminTheme.backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: const Text('Start Time'),
                                  subtitle:
                                      Text(_startTime?.format(context) ?? 'Select time'),
                                  trailing: const Icon(Icons.access_time),
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: _startTime ?? TimeOfDay.now(),
                                    );
                                    if (time != null) {
                                      setState(() => _startTime = time);
                                    }
                                  },
                                  tileColor: AdminTheme.backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ListTile(
                                  title: const Text('End Time'),
                                  subtitle:
                                      Text(_endTime?.format(context) ?? 'Select time'),
                                  trailing: const Icon(Icons.access_time),
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: _endTime ?? TimeOfDay.now(),
                                    );
                                    if (time != null) {
                                      setState(() => _endTime = time);
                                    }
                                  },
                                  tileColor: AdminTheme.backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _zone,
                            decoration: const InputDecoration(labelText: 'Zona'),
                            items: const [
                              DropdownMenuItem(value: 'A', child: Text('Zona A')),
                              DropdownMenuItem(value: 'B', child: Text('Zona B')),
                              DropdownMenuItem(value: 'C', child: Text('Zona C')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _zone = val);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _capacityController,
                            decoration: const InputDecoration(
                              labelText: 'Kapasitas (kg)',
                              hintText: 'Contoh: 50',
                              helperText: 'Total kapasitas berat yang diizinkan di slot ini',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Capacity is required';
                              }
                              final capacity = int.tryParse(value);
                              if (capacity == null || capacity <= 0) {
                                return 'Enter a valid positive number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Active'),
                            subtitle: const Text('Allow bookings for this slot'),
                            value: _isActive,
                            onChanged: (value) => setState(() => _isActive = value),
                            tileColor: AdminTheme.backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () => context.go('/admin/pickup-slots'),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleSave,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation(Colors.white),
                                          ),
                                        )
                                      : Text(isEdit ? 'Update Slot' : 'Create Slot'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
