import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class PickupSlotsState {
  final List<PickupSlotModel> slots;
  final List<PickupSlotModel> filteredSlots;
  final PickupSlotModel? selectedSlot;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? successMessage;

  final DateTime? filterDate;
  final String? filterStatus;
  final String searchQuery;

  const PickupSlotsState({
    this.slots = const [],
    this.filteredSlots = const [],
    this.selectedSlot,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
    this.filterDate,
    this.filterStatus,
    this.searchQuery = '',
  });

  PickupSlotsState copyWith({
    List<PickupSlotModel>? slots,
    List<PickupSlotModel>? filteredSlots,
    PickupSlotModel? selectedSlot,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? successMessage,
    DateTime? filterDate,
    String? filterStatus,
    String? searchQuery,
    bool clearSelectedSlot = false,
  }) {
    return PickupSlotsState(
      slots: slots ?? this.slots,
      filteredSlots: filteredSlots ?? this.filteredSlots,
      selectedSlot:
          clearSelectedSlot ? null : (selectedSlot ?? this.selectedSlot),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      successMessage: successMessage,
      filterDate: filterDate ?? this.filterDate,
      filterStatus: filterStatus ?? this.filterStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class PickupSlotsNotifier extends StateNotifier<PickupSlotsState> {
  final PickupSlotRepository _repository;

  PickupSlotsNotifier(this._repository) : super(const PickupSlotsState());

  Future<void> loadSlots({DateTime? startDate, DateTime? endDate}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final start =
          startDate ?? DateTime.now().subtract(const Duration(days: 7));
      final end = endDate ?? DateTime.now().add(const Duration(days: 30));

      final slots = await _repository.getAvailableSlotsByDate(start, 'all');

      slots.sort((a, b) {
        final dateCompare = b.date.compareTo(a.date);
        if (dateCompare != 0) return dateCompare;
        return a.timeRange.compareTo(b.timeRange);
      });

      state = state.copyWith(
        slots: slots,
        filteredSlots: slots,
        isLoading: false,
      );

      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load slots: $e',
      );
    }
  }

  Future<void> loadSlotById(String slotId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final slot = await _repository.getPickupSlotById(slotId);

      if (slot == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Slot not found',
        );
        return;
      }

      state = state.copyWith(
        selectedSlot: slot,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load slot: $e',
      );
    }
  }

  Future<bool> createSlot(PickupSlotModel slot) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      if (!_validateSlot(slot)) {
        state = state.copyWith(
          isSaving: false,
          error: 'Invalid slot data',
        );
        return false;
      }

      final hasConflict = await _checkSlotConflict(slot);
      if (hasConflict) {
        state = state.copyWith(
          isSaving: false,
          error: 'Time slot conflict detected',
        );
        return false;
      }

      final slotId = await _repository.createPickupSlot(slot);
      final newSlot = slot.copyWith(id: slotId);

      final updatedSlots = [...state.slots, newSlot];
      updatedSlots.sort((a, b) {
        final dateCompare = b.date.compareTo(a.date);
        if (dateCompare != 0) return dateCompare;
        return a.timeRange.compareTo(b.timeRange);
      });

      state = state.copyWith(
        slots: updatedSlots,
        isSaving: false,
        successMessage: 'Slot created successfully',
      );

      _applyFilters();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to create slot: $e',
      );
      return false;
    }
  }

  Future<bool> updateSlot(String slotId, PickupSlotModel slot) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      if (!_validateSlot(slot)) {
        state = state.copyWith(
          isSaving: false,
          error: 'Invalid slot data',
        );
        return false;
      }

      final hasConflict = await _checkSlotConflict(slot, excludeId: slotId);
      if (hasConflict) {
        state = state.copyWith(
          isSaving: false,
          error: 'Time slot conflict detected',
        );
        return false;
      }

      final updates = slot.toJson();
      updates.remove('id');
      await _repository.updatePickupSlot(slotId, updates);

      final updatedSlots = state.slots.map((s) {
        return s.id == slotId ? slot.copyWith(id: slotId) : s;
      }).toList();

      updatedSlots.sort((a, b) {
        final dateCompare = b.date.compareTo(a.date);
        if (dateCompare != 0) return dateCompare;
        return a.timeRange.compareTo(b.timeRange);
      });

      state = state.copyWith(
        slots: updatedSlots,
        selectedSlot: slot.copyWith(id: slotId),
        isSaving: false,
        successMessage: 'Slot updated successfully',
      );

      _applyFilters();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update slot: $e',
      );
      return false;
    }
  }

  Future<bool> deleteSlot(String slotId) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      final slot = state.slots.firstWhere((s) => s.id == slotId);
      if (slot.usedWeightKg > 0) {
        state = state.copyWith(
          isSaving: false,
          error: 'Cannot delete slot with existing bookings',
        );
        return false;
      }

      await _repository.deletePickupSlot(slotId);

      final updatedSlots = state.slots.where((s) => s.id != slotId).toList();

      state = state.copyWith(
        slots: updatedSlots,
        isSaving: false,
        successMessage: 'Slot deleted successfully',
      );

      _applyFilters();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to delete slot: $e',
      );
      return false;
    }
  }

  Future<bool> toggleSlotStatus(String slotId) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final slot = state.slots.firstWhere((s) => s.id == slotId);
      final newStatus = !slot.isActive;

      await _repository.updatePickupSlot(slotId, {'isActive': newStatus});

      final updatedSlots = state.slots.map((s) {
        return s.id == slotId ? s.copyWith(isActive: newStatus) : s;
      }).toList();

      state = state.copyWith(
        slots: updatedSlots,
        isSaving: false,
        successMessage: newStatus ? 'Slot activated' : 'Slot deactivated',
      );

      _applyFilters();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to toggle status: $e',
      );
      return false;
    }
  }

  void setDateFilter(DateTime? date) {
    state = state.copyWith(filterDate: date);
    _applyFilters();
  }

  void setStatusFilter(String? status) {
    state = state.copyWith(filterStatus: status);
    _applyFilters();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void clearFilters() {
    state = state.copyWith(
      filterDate: null,
      filterStatus: null,
      searchQuery: '',
      filteredSlots: state.slots,
    );
  }

  void _applyFilters() {
    var filtered = state.slots;

    if (state.filterDate != null) {
      final targetDate = state.filterDate!;
      filtered = filtered.where((slot) {
        return slot.date.year == targetDate.year &&
            slot.date.month == targetDate.month &&
            slot.date.day == targetDate.day;
      }).toList();
    }

    if (state.filterStatus != null) {
      final isActive = state.filterStatus == 'active';
      filtered = filtered.where((slot) => slot.isActive == isActive).toList();
    }

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((slot) {
        return slot.timeRange.toLowerCase().contains(query) ||
            slot.zone.toLowerCase().contains(query) ||
            slot.date.toString().contains(query);
      }).toList();
    }

    state = state.copyWith(filteredSlots: filtered);
  }

  bool _validateSlot(PickupSlotModel slot) {
    if (slot.capacityWeightKg <= 0) return false;

    final now = DateTime.now();
    final slotDate = DateTime(slot.date.year, slot.date.month, slot.date.day);
    final today = DateTime(now.year, now.month, now.day);
    if (slotDate.isBefore(today)) return false;

    if (slot.timeRange.isEmpty) return false;
    if (slot.zone.isEmpty) return false;

    return true;
  }

  Future<bool> _checkSlotConflict(
    PickupSlotModel slot, {
    String? excludeId,
  }) async {
    try {
      final slotsOnSameDate = state.slots.where((s) {
        if (excludeId != null && s.id == excludeId) return false;
        return s.zone == slot.zone &&
            s.date.year == slot.date.year &&
            s.date.month == slot.date.month &&
            s.date.day == slot.date.day;
      }).toList();

      for (final existingSlot in slotsOnSameDate) {
        if (_timeRangesOverlap(slot.timeRange, existingSlot.timeRange)) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error checking conflict: $e');
      return false;
    }
  }

  bool _timeRangesOverlap(String range1, String range2) {
    try {
      final parts1 = range1.split('-').map((s) => s.trim()).toList();
      final parts2 = range2.split('-').map((s) => s.trim()).toList();

      if (parts1.length != 2 || parts2.length != 2) return false;

      final start1 = _timeToMinutes(parts1[0]);
      final end1 = _timeToMinutes(parts1[1]);
      final start2 = _timeToMinutes(parts2[0]);
      final end2 = _timeToMinutes(parts2[1]);

      if (start1 == null || end1 == null || start2 == null || end2 == null) {
        return false;
      }

      return start1 < end2 && end1 > start2;
    } catch (e) {
      return false;
    }
  }

  int? _timeToMinutes(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) return null;
      final hours = int.tryParse(parts[0]);
      final minutes = int.tryParse(parts[1]);
      if (hours == null || minutes == null) return null;
      return hours * 60 + minutes;
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void selectSlot(PickupSlotModel slot) {
    state = state.copyWith(selectedSlot: slot);
  }

  void clearSelectedSlot() {
    state = state.copyWith(clearSelectedSlot: true);
  }
}

final pickupSlotRepositoryProvider = Provider<PickupSlotRepository>((ref) {
  return PickupSlotRepository();
});

final pickupSlotsProvider =
    StateNotifierProvider<PickupSlotsNotifier, PickupSlotsState>((ref) {
  final repository = ref.watch(pickupSlotRepositoryProvider);
  return PickupSlotsNotifier(repository);
});

final allPickupSlotsProvider = Provider<List<PickupSlotModel>>((ref) {
  return ref.watch(pickupSlotsProvider).slots;
});

final filteredPickupSlotsProvider = Provider<List<PickupSlotModel>>((ref) {
  return ref.watch(pickupSlotsProvider).filteredSlots;
});

final selectedPickupSlotProvider = Provider<PickupSlotModel?>((ref) {
  return ref.watch(pickupSlotsProvider).selectedSlot;
});

final pickupSlotsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(pickupSlotsProvider).isLoading;
});

final pickupSlotsSavingProvider = Provider<bool>((ref) {
  return ref.watch(pickupSlotsProvider).isSaving;
});

final pickupSlotsErrorProvider = Provider<String?>((ref) {
  return ref.watch(pickupSlotsProvider).error;
});

final pickupSlotsSuccessProvider = Provider<String?>((ref) {
  return ref.watch(pickupSlotsProvider).successMessage;
});
