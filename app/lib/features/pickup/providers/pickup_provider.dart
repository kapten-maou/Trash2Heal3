import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../auth/providers/auth_provider.dart';

/// Waste categories with rates
const wasteCategories = [
  {'id': 'plastik', 'name': 'Plastik', 'icon': '🍶', 'rate': 50},
  {'id': 'kaca', 'name': 'Kaca', 'icon': '🍾', 'rate': 30},
  {'id': 'kaleng', 'name': 'Kaleng', 'icon': '🥫', 'rate': 40},
  {'id': 'kardus', 'name': 'Kardus', 'icon': '📦', 'rate': 20},
  {'id': 'kain', 'name': 'Kain', 'icon': '👕', 'rate': 25},
  {'id': 'keramik', 'name': 'Keramik', 'icon': '🧱', 'rate': 15},
];

/// Pickup state
class PickupState {
  final int currentStep; // 1, 2, 3, 4
  final Map<String, double> quantities; // category -> kg
  final AddressModel? selectedAddress;
  final PickupSlotModel? selectedSlot;
  final DateTime? selectedDate;
  final bool isLoading;
  final String? errorMessage;

  const PickupState({
    this.currentStep = 1,
    this.quantities = const {},
    this.selectedAddress,
    this.selectedSlot,
    this.selectedDate,
    this.isLoading = false,
    this.errorMessage,
  });

  // Computed properties
  double get totalWeight {
    return quantities.values.fold(0, (sum, weight) => sum + weight);
  }

  int get estimatedPoints {
    double points = 0;
    quantities.forEach((category, weight) {
      final categoryData = wasteCategories.firstWhere(
        (c) => c['id'] == category,
        orElse: () => {'rate': 0},
      );
      points += weight * (categoryData['rate'] as int);
    });
    return points.round();
  }

  bool get canProceedFromStep1 => totalWeight > 0;
  bool get canProceedFromStep2 => selectedAddress != null;
  bool get canProceedFromStep3 => selectedSlot != null && selectedDate != null;

  PickupState copyWith({
    int? currentStep,
    Map<String, double>? quantities,
    AddressModel? selectedAddress,
    PickupSlotModel? selectedSlot,
    DateTime? selectedDate,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PickupState(
      currentStep: currentStep ?? this.currentStep,
      quantities: quantities ?? this.quantities,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  PickupState clearAddress() {
    return PickupState(
      currentStep: currentStep,
      quantities: quantities,
      selectedAddress: null,
      selectedSlot: selectedSlot,
      selectedDate: selectedDate,
      isLoading: isLoading,
    );
  }

  PickupState clearSlot() {
    return PickupState(
      currentStep: currentStep,
      quantities: quantities,
      selectedAddress: selectedAddress,
      selectedSlot: null,
      // Jangan reset selectedDate agar tombol "Lanjut" tetap aktif setelah pilih tanggal
      selectedDate: selectedDate,
      isLoading: isLoading,
    );
  }
}

/// Pickup notifier
class PickupNotifier extends StateNotifier<PickupState> {
  final PickupRepository _pickupRepository;
  final PickupSlotRepository _slotRepository;
  final Ref _ref;

  PickupNotifier(
    this._pickupRepository,
    this._slotRepository,
    this._ref,
  ) : super(const PickupState());

  // Step 1: Quantities
  void updateQuantity(String category, double weight) {
    final newQuantities = Map<String, double>.from(state.quantities);
    if (weight <= 0) {
      newQuantities.remove(category);
    } else {
      newQuantities[category] = weight;
    }
    state = state.copyWith(quantities: newQuantities);
  }

  void incrementQuantity(String category) {
    final current = state.quantities[category] ?? 0;
    updateQuantity(category, current + 0.5);
  }

  void decrementQuantity(String category) {
    final current = state.quantities[category] ?? 0;
    if (current > 0) {
      updateQuantity(category, current - 0.5);
    }
  }

  // Step 2: Address
  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  // Step 3: Schedule
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date, selectedSlot: null);
  }

  void selectSlot(PickupSlotModel slot) {
    state = state.copyWith(selectedSlot: slot);
  }

  // Navigation
  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 4) {
      state = state.copyWith(currentStep: step);
    }
  }

  // Submit pickup request
  Future<PickupSubmissionResult?> submitPickup() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final authState = _ref.read(authProvider);
      if (authState.user == null) {
        throw 'User not authenticated';
      }

      if (!state.canProceedFromStep1 ||
          !state.canProceedFromStep2 ||
          !state.canProceedFromStep3) {
        throw 'Incomplete pickup data';
      }

      // Generate OTP
      final otp = _generateOTP();

      // Reserve slot capacity before creating the request
      final reserved = await _slotRepository.reserveSlotCapacity(
        state.selectedSlot!.id,
        state.totalWeight,
      );

      if (!reserved) {
        throw 'Slot sudah penuh, pilih waktu lain';
      }

      // Convert quantities to the Map<String, int> expected by shared model
      final quantities = state.quantities.map(
        (category, weight) => MapEntry(category, weight.round()),
      );

      // Create pickup request using shared model/repository
      final pickupRequest = PickupRequestModel(
        id: '',
        userId: authState.user!.uid,
        quantities: quantities,
        estimatedWeight: state.totalWeight,
        estimatedPoints: state.estimatedPoints,
        addressSnapshot: state.selectedAddress!.toFirestore(),
        pickupDate: state.selectedDate!,
        timeRange: state.selectedSlot!.timeRange,
        zone: state.selectedSlot!.zone,
        status: PickupStatus.pending,
        otp: otp,
      );

      final docRef = await _pickupRepository.createPickupRequest(
        pickupRequest,
      );

      // Reset state
      state = const PickupState();

      return PickupSubmissionResult(id: docRef, otp: otp);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  String _generateOTP() {
    return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
  }

  void reset() {
    state = const PickupState();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSlot() {
    state = state.clearSlot();
  }
}

/// Provider
final pickupProvider =
    StateNotifierProvider<PickupNotifier, PickupState>((ref) {
  return PickupNotifier(
    PickupRepository(),
    PickupSlotRepository(),
    ref,
  );
});

/// Simple DTO for pickup submission result
class PickupSubmissionResult {
  final String id;
  final String otp;

  PickupSubmissionResult({required this.id, required this.otp});
}
