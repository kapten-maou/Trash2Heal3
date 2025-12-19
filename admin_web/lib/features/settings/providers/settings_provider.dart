// admin_web/lib/features/settings/providers/settings_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../../common/providers/firebase_providers.dart';


// ============================================================================
// APP SETTINGS MODEL
// ============================================================================

class AppSettings {
  // General settings
  final String appName;
  final String appVersion;
  final bool maintenanceMode;
  final String? maintenanceMessage;

  // Point conversion settings
  final double pointsToRupiahRate; // 1 point = X rupiah
  final int minRedeemPoints;
  final int maxRedeemPoints;

  // Membership plans
  final Map<String, MembershipPlan> membershipPlans;

  // Pickup settings
  final int maxPickupPerDay;
  final int minPickupWeight; // in kg
  final int maxPickupWeight; // in kg
  final List<String> supportedWasteTypes;

  // Notification settings
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final bool enableSmsNotifications;

  // Payment settings
  final List<String> enabledPaymentMethods;
  final double minPaymentAmount;
  final double maxPaymentAmount;

  // Event settings
  final int maxEventParticipants;
  final int eventCouponExpireDays;

  const AppSettings({
    this.appName = 'TRASH2HEAL',
    this.appVersion = '1.0.0',
    this.maintenanceMode = false,
    this.maintenanceMessage,
    this.pointsToRupiahRate = 100.0, // 100 points = Rp 1
    this.minRedeemPoints = 10000,
    this.maxRedeemPoints = 1000000,
    this.membershipPlans = const {},
    this.maxPickupPerDay = 10,
    this.minPickupWeight = 1,
    this.maxPickupWeight = 100,
    this.supportedWasteTypes = const [
      'plastic',
      'paper',
      'metal',
      'glass',
      'organic'
    ],
    this.enablePushNotifications = true,
    this.enableEmailNotifications = true,
    this.enableSmsNotifications = false,
    this.enabledPaymentMethods = const ['bank_transfer', 'e_wallet'],
    this.minPaymentAmount = 10000.0,
    this.maxPaymentAmount = 10000000.0,
    this.maxEventParticipants = 1000,
    this.eventCouponExpireDays = 30,
  });

  AppSettings copyWith({
    String? appName,
    String? appVersion,
    bool? maintenanceMode,
    String? maintenanceMessage,
    double? pointsToRupiahRate,
    int? minRedeemPoints,
    int? maxRedeemPoints,
    Map<String, MembershipPlan>? membershipPlans,
    int? maxPickupPerDay,
    int? minPickupWeight,
    int? maxPickupWeight,
    List<String>? supportedWasteTypes,
    bool? enablePushNotifications,
    bool? enableEmailNotifications,
    bool? enableSmsNotifications,
    List<String>? enabledPaymentMethods,
    double? minPaymentAmount,
    double? maxPaymentAmount,
    int? maxEventParticipants,
    int? eventCouponExpireDays,
  }) {
    return AppSettings(
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      maintenanceMessage: maintenanceMessage ?? this.maintenanceMessage,
      pointsToRupiahRate: pointsToRupiahRate ?? this.pointsToRupiahRate,
      minRedeemPoints: minRedeemPoints ?? this.minRedeemPoints,
      maxRedeemPoints: maxRedeemPoints ?? this.maxRedeemPoints,
      membershipPlans: membershipPlans ?? this.membershipPlans,
      maxPickupPerDay: maxPickupPerDay ?? this.maxPickupPerDay,
      minPickupWeight: minPickupWeight ?? this.minPickupWeight,
      maxPickupWeight: maxPickupWeight ?? this.maxPickupWeight,
      supportedWasteTypes: supportedWasteTypes ?? this.supportedWasteTypes,
      enablePushNotifications:
          enablePushNotifications ?? this.enablePushNotifications,
      enableEmailNotifications:
          enableEmailNotifications ?? this.enableEmailNotifications,
      enableSmsNotifications:
          enableSmsNotifications ?? this.enableSmsNotifications,
      enabledPaymentMethods:
          enabledPaymentMethods ?? this.enabledPaymentMethods,
      minPaymentAmount: minPaymentAmount ?? this.minPaymentAmount,
      maxPaymentAmount: maxPaymentAmount ?? this.maxPaymentAmount,
      maxEventParticipants: maxEventParticipants ?? this.maxEventParticipants,
      eventCouponExpireDays:
          eventCouponExpireDays ?? this.eventCouponExpireDays,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'appVersion': appVersion,
      'maintenanceMode': maintenanceMode,
      'maintenanceMessage': maintenanceMessage,
      'pointsToRupiahRate': pointsToRupiahRate,
      'minRedeemPoints': minRedeemPoints,
      'maxRedeemPoints': maxRedeemPoints,
      'membershipPlans':
          membershipPlans.map((key, plan) => MapEntry(key, plan.toMap())),
      'maxPickupPerDay': maxPickupPerDay,
      'minPickupWeight': minPickupWeight,
      'maxPickupWeight': maxPickupWeight,
      'supportedWasteTypes': supportedWasteTypes,
      'enablePushNotifications': enablePushNotifications,
      'enableEmailNotifications': enableEmailNotifications,
      'enableSmsNotifications': enableSmsNotifications,
      'enabledPaymentMethods': enabledPaymentMethods,
      'minPaymentAmount': minPaymentAmount,
      'maxPaymentAmount': maxPaymentAmount,
      'maxEventParticipants': maxEventParticipants,
      'eventCouponExpireDays': eventCouponExpireDays,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      appName: map['appName'] ?? 'TRASH2HEAL',
      appVersion: map['appVersion'] ?? '1.0.0',
      maintenanceMode: map['maintenanceMode'] ?? false,
      maintenanceMessage: map['maintenanceMessage'],
      pointsToRupiahRate:
          (map['pointsToRupiahRate'] as num?)?.toDouble() ?? 100.0,
      minRedeemPoints: map['minRedeemPoints'] ?? 10000,
      maxRedeemPoints: map['maxRedeemPoints'] ?? 1000000,
      membershipPlans: (map['membershipPlans'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, MembershipPlan.fromMap(value))) ??
          {},
      maxPickupPerDay: map['maxPickupPerDay'] ?? 10,
      minPickupWeight: map['minPickupWeight'] ?? 1,
      maxPickupWeight: map['maxPickupWeight'] ?? 100,
      supportedWasteTypes: List<String>.from(map['supportedWasteTypes'] ??
          ['plastic', 'paper', 'metal', 'glass', 'organic']),
      enablePushNotifications: map['enablePushNotifications'] ?? true,
      enableEmailNotifications: map['enableEmailNotifications'] ?? true,
      enableSmsNotifications: map['enableSmsNotifications'] ?? false,
      enabledPaymentMethods: List<String>.from(
          map['enabledPaymentMethods'] ?? ['bank_transfer', 'e_wallet']),
      minPaymentAmount:
          (map['minPaymentAmount'] as num?)?.toDouble() ?? 10000.0,
      maxPaymentAmount:
          (map['maxPaymentAmount'] as num?)?.toDouble() ?? 10000000.0,
      maxEventParticipants: map['maxEventParticipants'] ?? 1000,
      eventCouponExpireDays: map['eventCouponExpireDays'] ?? 30,
    );
  }
}

// ============================================================================
// MEMBERSHIP PLAN MODEL
// ============================================================================

class MembershipPlan {
  final String name;
  final String description;
  final double price;
  final int durationDays;
  final Map<String, dynamic> benefits;
  final bool isActive;

  const MembershipPlan({
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.benefits,
    this.isActive = true,
  });

  MembershipPlan copyWith({
    String? name,
    String? description,
    double? price,
    int? durationDays,
    Map<String, dynamic>? benefits,
    bool? isActive,
  }) {
    return MembershipPlan(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      benefits: benefits ?? this.benefits,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'durationDays': durationDays,
      'benefits': benefits,
      'isActive': isActive,
    };
  }

  factory MembershipPlan.fromMap(Map<String, dynamic> map) {
    return MembershipPlan(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      durationDays: map['durationDays'] ?? 30,
      benefits: Map<String, dynamic>.from(map['benefits'] ?? {}),
      isActive: map['isActive'] ?? true,
    );
  }
}

// ============================================================================
// SETTINGS STATE
// ============================================================================

class SettingsState {
  final AppSettings settings;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? successMessage;

  const SettingsState({
    required this.settings,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
  });

  SettingsState copyWith({
    AppSettings? settings,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? successMessage,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      successMessage: successMessage,
    );
  }
}

// ============================================================================
// SETTINGS PROVIDER
// ============================================================================

class SettingsNotifier extends StateNotifier<SettingsState> {
  final FirebaseFirestore _firestore;
  static const String _settingsDocId = 'app_settings';

  SettingsNotifier(this._firestore)
      : super(SettingsState(settings: AppSettings()));

  // --------------------------------------------------------------------------
  // LOAD SETTINGS
  // --------------------------------------------------------------------------

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final doc =
          await _firestore.collection('settings').doc(_settingsDocId).get();

      if (doc.exists && doc.data() != null) {
        final settings = AppSettings.fromMap(doc.data()!);
        state = state.copyWith(
          settings: settings,
          isLoading: false,
        );
      } else {
        // Initialize with default settings
        await _initializeDefaultSettings();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load settings: $e',
      );
    }
  }

  // --------------------------------------------------------------------------
  // INITIALIZE DEFAULT SETTINGS
  // --------------------------------------------------------------------------

  Future<void> _initializeDefaultSettings() async {
    try {
      final defaultSettings = AppSettings(
        membershipPlans: {
          'basic': MembershipPlan(
            name: 'Basic',
            description: 'Free tier with basic features',
            price: 0.0,
            durationDays: 365,
            benefits: {
              'maxPickupsPerMonth': 4,
              'prioritySupport': false,
              'discountRate': 0.0,
            },
          ),
          'premium': MembershipPlan(
            name: 'Premium',
            description: 'Enhanced features and priority support',
            price: 50000.0,
            durationDays: 30,
            benefits: {
              'maxPickupsPerMonth': 10,
              'prioritySupport': true,
              'discountRate': 0.1, // 10% discount
              'bonusPoints': 1000,
            },
          ),
          'gold': MembershipPlan(
            name: 'Gold',
            description: 'Premium features with unlimited pickups',
            price: 100000.0,
            durationDays: 30,
            benefits: {
              'maxPickupsPerMonth': -1, // Unlimited
              'prioritySupport': true,
              'discountRate': 0.2, // 20% discount
              'bonusPoints': 5000,
              'freeDelivery': true,
            },
          ),
        },
      );

      await _firestore
          .collection('settings')
          .doc(_settingsDocId)
          .set(defaultSettings.toMap());

      state = state.copyWith(
        settings: defaultSettings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize settings: $e',
      );
    }
  }

  // --------------------------------------------------------------------------
  // UPDATE SETTINGS
  // --------------------------------------------------------------------------

  Future<bool> updateSettings(AppSettings settings) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      await _firestore
          .collection('settings')
          .doc(_settingsDocId)
          .set(settings.toMap());

      state = state.copyWith(
        settings: settings,
        isSaving: false,
        successMessage: 'Settings updated successfully',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update settings: $e',
      );
      return false;
    }
  }

  // --------------------------------------------------------------------------
  // UPDATE GENERAL SETTINGS
  // --------------------------------------------------------------------------

  Future<bool> updateGeneralSettings({
    String? appName,
    String? appVersion,
    bool? maintenanceMode,
    String? maintenanceMessage,
  }) async {
    final updatedSettings = state.settings.copyWith(
      appName: appName,
      appVersion: appVersion,
      maintenanceMode: maintenanceMode,
      maintenanceMessage: maintenanceMessage,
    );

    return await updateSettings(updatedSettings);
  }

  // --------------------------------------------------------------------------
  // UPDATE POINT CONVERSION SETTINGS
  // --------------------------------------------------------------------------

  Future<bool> updatePointSettings({
    double? pointsToRupiahRate,
    int? minRedeemPoints,
    int? maxRedeemPoints,
  }) async {
    final updatedSettings = state.settings.copyWith(
      pointsToRupiahRate: pointsToRupiahRate,
      minRedeemPoints: minRedeemPoints,
      maxRedeemPoints: maxRedeemPoints,
    );

    return await updateSettings(updatedSettings);
  }

  // --------------------------------------------------------------------------
  // UPDATE PICKUP SETTINGS
  // --------------------------------------------------------------------------

  Future<bool> updatePickupSettings({
    int? maxPickupPerDay,
    int? minPickupWeight,
    int? maxPickupWeight,
    List<String>? supportedWasteTypes,
  }) async {
    final updatedSettings = state.settings.copyWith(
      maxPickupPerDay: maxPickupPerDay,
      minPickupWeight: minPickupWeight,
      maxPickupWeight: maxPickupWeight,
      supportedWasteTypes: supportedWasteTypes,
    );

    return await updateSettings(updatedSettings);
  }

  // --------------------------------------------------------------------------
  // UPDATE NOTIFICATION SETTINGS
  // --------------------------------------------------------------------------

  Future<bool> updateNotificationSettings({
    bool? enablePushNotifications,
    bool? enableEmailNotifications,
    bool? enableSmsNotifications,
  }) async {
    final updatedSettings = state.settings.copyWith(
      enablePushNotifications: enablePushNotifications,
      enableEmailNotifications: enableEmailNotifications,
      enableSmsNotifications: enableSmsNotifications,
    );

    return await updateSettings(updatedSettings);
  }

  // --------------------------------------------------------------------------
  // UPDATE PAYMENT SETTINGS
  // --------------------------------------------------------------------------

  Future<bool> updatePaymentSettings({
    List<String>? enabledPaymentMethods,
    double? minPaymentAmount,
    double? maxPaymentAmount,
  }) async {
    final updatedSettings = state.settings.copyWith(
      enabledPaymentMethods: enabledPaymentMethods,
      minPaymentAmount: minPaymentAmount,
      maxPaymentAmount: maxPaymentAmount,
    );

    return await updateSettings(updatedSettings);
  }

  // --------------------------------------------------------------------------
  // UPDATE EVENT SETTINGS
  // --------------------------------------------------------------------------

  Future<bool> updateEventSettings({
    int? maxEventParticipants,
    int? eventCouponExpireDays,
  }) async {
    final updatedSettings = state.settings.copyWith(
      maxEventParticipants: maxEventParticipants,
      eventCouponExpireDays: eventCouponExpireDays,
    );

    return await updateSettings(updatedSettings);
  }

  // --------------------------------------------------------------------------
  // UPDATE MEMBERSHIP PLAN
  // --------------------------------------------------------------------------

  Future<bool> updateMembershipPlan(String tier, MembershipPlan plan) async {
    final updatedPlans =
        Map<String, MembershipPlan>.from(state.settings.membershipPlans);
    updatedPlans[tier] = plan;

    final updatedSettings = state.settings.copyWith(
      membershipPlans: updatedPlans,
    );

    return await updateSettings(updatedSettings);
  }

  // --------------------------------------------------------------------------
  // DELETE MEMBERSHIP PLAN
  // --------------------------------------------------------------------------

  Future<bool> deleteMembershipPlan(String tier) async {
    // Can't delete basic plan
    if (tier == 'basic') {
      state = state.copyWith(
        error: 'Cannot delete basic membership plan',
      );
      return false;
    }

    final updatedPlans =
        Map<String, MembershipPlan>.from(state.settings.membershipPlans);
    updatedPlans.remove(tier);

    final updatedSettings = state.settings.copyWith(
      membershipPlans: updatedPlans,
    );

    return await updateSettings(updatedSettings);
  }

  // --------------------------------------------------------------------------
  // TOGGLE MAINTENANCE MODE
  // --------------------------------------------------------------------------

  Future<bool> toggleMaintenanceMode({String? message}) async {
    return await updateGeneralSettings(
      maintenanceMode: !state.settings.maintenanceMode,
      maintenanceMessage: message,
    );
  }

  // --------------------------------------------------------------------------
  // CALCULATE POINTS TO RUPIAH
  // --------------------------------------------------------------------------

  double calculatePointsToRupiah(int points) {
    return points / state.settings.pointsToRupiahRate;
  }

  // --------------------------------------------------------------------------
  // CALCULATE RUPIAH TO POINTS
  // --------------------------------------------------------------------------

  int calculateRupiahToPoints(double rupiah) {
    return (rupiah * state.settings.pointsToRupiahRate).round();
  }

  // --------------------------------------------------------------------------
  // VALIDATE REDEEM AMOUNT
  // --------------------------------------------------------------------------

  bool validateRedeemPoints(int points) {
    return points >= state.settings.minRedeemPoints &&
        points <= state.settings.maxRedeemPoints;
  }

  // --------------------------------------------------------------------------
  // GET MEMBERSHIP BENEFITS
  // --------------------------------------------------------------------------

  Map<String, dynamic>? getMembershipBenefits(String tier) {
    return state.settings.membershipPlans[tier]?.benefits;
  }

  // --------------------------------------------------------------------------
  // CLEAR MESSAGES
  // --------------------------------------------------------------------------

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }

  // --------------------------------------------------------------------------
  // REFRESH SETTINGS
  // --------------------------------------------------------------------------

  Future<void> refresh() async {
    await loadSettings();
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

// Settings State Notifier provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return SettingsNotifier(firestore);
});

// ============================================================================
// COMPUTED PROVIDERS (for convenience)
// ============================================================================

// App settings
final appSettingsProvider = Provider<AppSettings>((ref) {
  return ref.watch(settingsProvider).settings;
});

// Is loading
final settingsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isLoading;
});

// Is saving
final settingsSavingProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isSaving;
});

// Error message
final settingsErrorProvider = Provider<String?>((ref) {
  return ref.watch(settingsProvider).error;
});

// Success message
final settingsSuccessProvider = Provider<String?>((ref) {
  return ref.watch(settingsProvider).successMessage;
});

// Maintenance mode
final maintenanceModeProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).settings.maintenanceMode;
});

// Membership plans
final membershipPlansProvider = Provider<Map<String, MembershipPlan>>((ref) {
  return ref.watch(settingsProvider).settings.membershipPlans;
});

// Point conversion rate
final pointConversionRateProvider = Provider<double>((ref) {
  return ref.watch(settingsProvider).settings.pointsToRupiahRate;
});

// Supported waste types
final supportedWasteTypesProvider = Provider<List<String>>((ref) {
  return ref.watch(settingsProvider).settings.supportedWasteTypes;
});

// Enabled payment methods
final enabledPaymentMethodsProvider = Provider<List<String>>((ref) {
  return ref.watch(settingsProvider).settings.enabledPaymentMethods;
});
