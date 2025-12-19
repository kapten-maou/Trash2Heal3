import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class PickupRatesState {
  final List<PickupRateModel> rates;
  final List<PickupRateModel> filteredRates;
  final PickupRateModel? selectedRate;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? successMessage;

  final String? filterCategory;
  final String? filterStatus;
  final String searchQuery;

  const PickupRatesState({
    this.rates = const [],
    this.filteredRates = const [],
    this.selectedRate,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
    this.filterCategory,
    this.filterStatus,
    this.searchQuery = '',
  });

  PickupRatesState copyWith({
    List<PickupRateModel>? rates,
    List<PickupRateModel>? filteredRates,
    PickupRateModel? selectedRate,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? successMessage,
    String? filterCategory,
    String? filterStatus,
    String? searchQuery,
    bool clearSelectedRate = false,
  }) {
    return PickupRatesState(
      rates: rates ?? this.rates,
      filteredRates: filteredRates ?? this.filteredRates,
      selectedRate:
          clearSelectedRate ? null : (selectedRate ?? this.selectedRate),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      successMessage: successMessage,
      filterCategory: filterCategory ?? this.filterCategory,
      filterStatus: filterStatus ?? this.filterStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class PickupRatesNotifier extends StateNotifier<PickupRatesState> {
  final PickupRateRepository _repository;

  PickupRatesNotifier(this._repository) : super(const PickupRatesState());

  Future<void> loadRates() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final rates = await _repository.getAllActiveRates();

      rates.sort((a, b) {
        final categoryCompare = a.category.compareTo(b.category);
        if (categoryCompare != 0) return categoryCompare;
        return b.pointsPerKg.compareTo(a.pointsPerKg);
      });

      state = state.copyWith(
        rates: rates,
        filteredRates: rates,
        isLoading: false,
      );

      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load rates: $e',
      );
    }
  }

  Future<void> loadRateById(String rateId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final rate = await _repository.getPickupRateById(rateId);

      if (rate == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Rate not found',
        );
        return;
      }

      state = state.copyWith(
        selectedRate: rate,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load rate: $e',
      );
    }
  }

  Future<List<PickupRateModel>> getRatesByCategory(String category) async {
    try {
      final rate = await _repository.getRateByCategory(category);
      return rate != null ? [rate] : [];
    } catch (e) {
      print('Error getting rates by category: $e');
      return [];
    }
  }

  Future<bool> createRate(PickupRateModel rate) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      if (!_validateRate(rate)) {
        state = state.copyWith(
          isSaving: false,
          error: 'Invalid rate data',
        );
        return false;
      }

      await _repository.createPickupRate(rate);
      await loadRates();

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Rate created successfully',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to create rate: $e',
      );
      return false;
    }
  }

  Future<bool> updateRate(String rateId, PickupRateModel rate) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      if (!_validateRate(rate)) {
        state = state.copyWith(
          isSaving: false,
          error: 'Invalid rate data',
        );
        return false;
      }

      final updates = rate.toJson();
      updates.remove('id');
      await _repository.updatePickupRate(rateId, updates);

      await loadRates();

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Rate updated successfully',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update rate: $e',
      );
      return false;
    }
  }

  Future<bool> deleteRate(String rateId) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      await _repository.deletePickupRate(rateId);

      final updatedRates = state.rates.where((r) => r.id != rateId).toList();

      state = state.copyWith(
        rates: updatedRates,
        isSaving: false,
        successMessage: 'Rate deleted successfully',
      );

      _applyFilters();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to delete rate: $e',
      );
      return false;
    }
  }

  Future<bool> toggleRateStatus(String rateId) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final rate = state.rates.firstWhere((r) => r.id == rateId);
      final updatedRate = rate.copyWith(isActive: !rate.isActive);

      final updates = updatedRate.toJson();
      updates.remove('id');
      await _repository.updatePickupRate(rateId, updates);

      final updatedRates = state.rates.map((r) {
        return r.id == rateId ? updatedRate : r;
      }).toList();

      state = state.copyWith(
        rates: updatedRates,
        isSaving: false,
        successMessage:
            updatedRate.isActive ? 'Rate activated' : 'Rate deactivated',
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

  void setCategoryFilter(String? category) {
    state = state.copyWith(filterCategory: category);
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
      filterCategory: null,
      filterStatus: null,
      searchQuery: '',
      filteredRates: state.rates,
    );
  }

  void _applyFilters() {
    var filtered = state.rates;

    if (state.filterCategory != null) {
      filtered = filtered
          .where((rate) => rate.category == state.filterCategory)
          .toList();
    }

    if (state.filterStatus != null) {
      final isActive = state.filterStatus == 'active';
      filtered = filtered.where((rate) => rate.isActive == isActive).toList();
    }

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((rate) {
        return rate.displayName.toLowerCase().contains(query) ||
            rate.category.toLowerCase().contains(query) ||
            (rate.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    state = state.copyWith(filteredRates: filtered);
  }

  bool _validateRate(PickupRateModel rate) {
    if (rate.category.isEmpty) return false;
    if (rate.displayName.isEmpty) return false;
    if (rate.pointsPerKg <= 0) return false;
    if (rate.avgWeightPerUnit <= 0) return false;
    return true;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void selectRate(PickupRateModel rate) {
    state = state.copyWith(selectedRate: rate);
  }

  void clearSelectedRate() {
    state = state.copyWith(clearSelectedRate: true);
  }
}

final pickupRateRepositoryProvider = Provider<PickupRateRepository>((ref) {
  return PickupRateRepository();
});

final pickupRatesProvider =
    StateNotifierProvider<PickupRatesNotifier, PickupRatesState>((ref) {
  final repository = ref.watch(pickupRateRepositoryProvider);
  return PickupRatesNotifier(repository);
});

final allPickupRatesProvider = Provider<List<PickupRateModel>>((ref) {
  return ref.watch(pickupRatesProvider).rates;
});

final filteredPickupRatesProvider = Provider<List<PickupRateModel>>((ref) {
  return ref.watch(pickupRatesProvider).filteredRates;
});

final selectedPickupRateProvider = Provider<PickupRateModel?>((ref) {
  return ref.watch(pickupRatesProvider).selectedRate;
});

final pickupRatesLoadingProvider = Provider<bool>((ref) {
  return ref.watch(pickupRatesProvider).isLoading;
});

final pickupRatesSavingProvider = Provider<bool>((ref) {
  return ref.watch(pickupRatesProvider).isSaving;
});

final pickupRatesErrorProvider = Provider<String?>((ref) {
  return ref.watch(pickupRatesProvider).error;
});

final pickupRatesSuccessProvider = Provider<String?>((ref) {
  return ref.watch(pickupRatesProvider).successMessage;
});
