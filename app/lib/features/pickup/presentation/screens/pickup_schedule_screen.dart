import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/pickup_provider.dart';
import '../../widgets/stepper_indicator.dart';
import '../../widgets/slot_card.dart';
import '../../../../common/widgets/primary_button.dart';

class PickupScheduleScreen extends ConsumerStatefulWidget {
  const PickupScheduleScreen({super.key});

  @override
  ConsumerState<PickupScheduleScreen> createState() =>
      _PickupScheduleScreenState();
}

class _PickupScheduleScreenState extends ConsumerState<PickupScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<PickupSlotModel> _slots = [];
  bool _isLoadingSlots = false;
  String _selectedZone = 'A';
  final Set<DateTime> _daysNoSlots = {};
  final Set<DateTime> _daysPrefetched = {};
  final _slotRepository = PickupSlotRepository();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _selectedDay = today;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectedZone =
          _inferZoneFromAddress(ref.read(pickupProvider).selectedAddress);
      ref.read(pickupProvider.notifier).selectDate(today);
      _loadSlotsForDate(today);
      _prefetchNoSlotDays(days: 14);
    });
  }

  Future<void> _loadSlotsForDate(DateTime date) async {
    setState(() {
      _isLoadingSlots = true;
    });

    // Reset pilihan slot ketika tanggal/zonanya berubah
    ref.read(pickupProvider.notifier).clearSlot();

    try {
      final slots =
          await _slotRepository.getAvailableSlotsByDate(date, _selectedZone);

      setState(() {
        _slots = slots;
        _isLoadingSlots = false;
        final dayKey = _normalizeDay(date);
        if (slots.isEmpty) {
          _daysNoSlots.add(dayKey);
        } else {
          _daysNoSlots.remove(dayKey);
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingSlots = false;
      });
    }
  }

  Future<void> _prefetchNoSlotDays({int days = 14}) async {
    final zone = _selectedZone;
    final today = DateTime.now();
    for (int i = 0; i < days; i++) {
      final date = today.add(Duration(days: i));
      if (_daysPrefetched.contains(date)) continue;
      final dayKey = _normalizeDay(date);
      try {
        final slots =
            await _slotRepository.getAvailableSlotsByDate(date, zone);
        if (slots.isEmpty) {
          setState(() {
            _daysNoSlots.add(dayKey);
          });
        }
        _daysPrefetched.add(date);
      } catch (_) {
        // ignore prefetch errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickupState = ref.watch(pickupProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(pickupProvider.notifier).previousStep();
            context.pop();
          },
        ),
        title: const Text('PICKUP',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: const StepperIndicator(currentStep: 3, totalSteps: 4),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 16),
                  _buildCalendar(),
                  const SizedBox(height: 16),
                  _buildZoneSelector(),
                  const SizedBox(height: 8),
                  Text(
                    'Zona menentukan ketersediaan slot. Anda berada di zona $_selectedZone.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Slot Tersedia (${_formatDate(_selectedDay ?? DateTime.now())}) • Zona $_selectedZone',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 16),
                  _isLoadingSlots
                      ? const Center(child: CircularProgressIndicator())
                      : _slots.isEmpty
                          ? _buildEmptySlots()
                          : Column(
                              children: _slots.map((slot) {
                                return SlotCard(
                                  slot: slot,
                                  isSelected:
                                      pickupState.selectedSlot?.id == slot.id,
                                  onTap: () {
                                    ref
                                        .read(pickupProvider.notifier)
                                        .selectSlot(slot);
                                  },
                                );
                              }).toList(),
                            ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2))
              ],
            ),
            child: SafeArea(
              top: false,
              child: PrimaryButton(
                text: 'LANJUT',
                onPressed: pickupState.canProceedFromStep3
                    ? () {
                        ref.read(pickupProvider.notifier).nextStep();
                        context.push('/pickup/review');
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 30)),
        focusedDay: _focusedDay,
        enabledDayPredicate: (day) =>
            !day.isBefore(DateTime.now().subtract(const Duration(days: 1))),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          ref.read(pickupProvider.notifier).selectDate(selectedDay);
          _loadSlotsForDate(selectedDay);
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Color(0xFFEF4444),
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final key = _normalizeDay(date);
            if (_daysNoSlots.contains(key)) {
              return const Positioned(
                bottom: 4,
                child: Icon(Icons.circle, size: 6, color: Color(0xFFEF4444)),
              );
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildZoneSelector() {
    final zones = ['A', 'B', 'C'];
    return Row(
      children: zones.map((zone) {
        final isSelected = _selectedZone == zone;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFFE5E7EB),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_selectedZone == zone) return;
                setState(() {
                  _selectedZone = zone;
                });
                if (_selectedDay != null) {
                  _loadSlotsForDate(_selectedDay!);
                }
              },
              child: Text(
                'Zona $zone',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFF111827),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptySlots() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: const [
            Icon(Icons.event_busy, size: 64, color: Color(0xFFD1D5DB)),
            SizedBox(height: 16),
            Text('Tidak ada slot tersedia',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280))),
            SizedBox(height: 8),
            Text('Pilih tanggal lain',
                style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
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
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]}';
  }

  String _inferZoneFromAddress(AddressModel? address) {
    if (address == null) return 'A';
    final city = address.city.trim().toUpperCase();
    if (city.startsWith('B')) return 'B';
    if (city.startsWith('C')) return 'C';
    return 'A';
  }

  DateTime _normalizeDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
