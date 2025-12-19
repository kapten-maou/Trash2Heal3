/// App Configuration Values & Constants
class AppValues {
  AppValues._();

  // ============================================
  // POINTS & REWARDS
  // ============================================

  /// Points per kg for each waste category (can be overridden by pickup_rates collection)
  static const Map<String, double> defaultPointRates = {
    'plastic': 100.0, // 100 points per kg
    'glass': 80.0,
    'can': 120.0,
    'cardboard': 50.0,
    'fabric': 70.0,
    'ceramicStone': 60.0,
  };

  /// Average weight per unit (for estimation)
  static const Map<String, double> defaultAvgWeightKg = {
    'plastic': 0.5, // 500g per unit
    'glass': 1.0,
    'can': 0.3,
    'cardboard': 0.8,
    'fabric': 0.4,
    'ceramicStone': 1.5,
  };

  /// Point to coupon conversion rate
  /// 1000 points = 1 coupon (Rp 10,000 value)
  static const double pointsToCouponRate = 1000.0;
  static const double couponValue = 10000.0; // IDR

  /// Point to balance conversion rate
  /// 100 points = Rp 1,000
  static const double pointsToBalanceRate = 100.0;
  static const double balanceValuePerPoint = 10.0; // IDR

  /// Minimum points required for redemption
  static const double minPointsForCoupon = 1000.0;
  static const double minPointsForBalance = 5000.0;

  /// Maximum redemption per transaction
  static const int maxCouponsPerRedemption = 10;
  static const double maxBalancePerRedemption = 1000000.0; // Rp 1 juta

  // ============================================
  // MEMBERSHIP
  // ============================================

  /// Membership pricing (monthly in IDR)
  static const Map<String, double> membershipPrices = {
    'basic': 0.0, // Free
    'silver': 49000.0,
    'gold': 99000.0,
    'platinum': 199000.0,
  };

  /// Membership benefits multipliers
  static const Map<String, double> membershipPointsMultiplier = {
    'basic': 1.0, // 1x points
    'silver': 1.2, // 1.2x points
    'gold': 1.5, // 1.5x points
    'platinum': 2.0, // 2x points
  };

  /// Membership priority pickup (days earlier)
  static const Map<String, int> membershipPriorityDays = {
    'basic': 0,
    'silver': 1,
    'gold': 2,
    'platinum': 3,
  };

  // ============================================
  // PICKUP SETTINGS
  // ============================================

  /// Pickup slot duration (minutes)
  static const int pickupSlotDuration = 120; // 2 hours

  /// Pickup capacity per slot (kg)
  static const double defaultSlotCapacityKg = 500.0;

  /// Minimum quantity per category
  static const int minQuantityPerCategory = 1;
  static const int maxQuantityPerCategory = 100;

  /// Minimum weight for pickup (kg)
  static const double minWeightForPickup = 1.0;

  /// Maximum reschedule allowed (days before pickup)
  static const int maxRescheduleDaysBefore = 1;

  /// Geofence threshold for courier check-in (meters)
  static const double geofenceThresholdMeters = 100.0;

  /// OTP expiry (minutes)
  static const int otpExpiryMinutes = 30;

  // ============================================
  // COUPON & VOUCHER
  // ============================================

  /// Coupon expiry duration (days)
  static const int couponExpiryDays = 90; // 3 months

  /// Voucher code length
  static const int voucherCodeLength = 12;

  // ============================================
  // UI SETTINGS
  // ============================================

  /// Pagination limit
  static const int paginationLimit = 20;

  /// Image quality (0-100)
  static const int imageQuality = 80;

  /// Max image size (MB)
  static const double maxImageSizeMB = 5.0;

  /// Animation duration (milliseconds)
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 300;
  static const int animationDurationLong = 500;

  /// Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  /// Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  /// Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  /// Button heights
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  /// Card elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // ============================================
  // VALIDATION
  // ============================================

  /// Password requirements
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;

  /// PIN requirements
  static const int pinLength = 6;

  /// Phone number format
  static const String phoneRegex = r'^(^\+62|62|^08)(\d{8,11})$';

  /// Username requirements
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const String usernameRegex = r'^[a-zA-Z0-9_]+$';

  // ============================================
  // DATETIME
  // ============================================

  /// Date formats
  static const String dateFormatShort = 'dd MMM yyyy';
  static const String dateFormatLong = 'EEEE, dd MMMM yyyy';
  static const String dateFormatFull = 'dd MMMM yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd MMM yyyy, HH:mm';

  /// Time zones
  static const String defaultTimezone = 'Asia/Jakarta';

  /// Business hours
  static const String businessHoursStart = '08:00';
  static const String businessHoursEnd = '17:00';

  // ============================================
  // NOTIFICATION
  // ============================================

  /// Notification expiry (days)
  static const int notificationExpiryDays = 30;

  /// Max notifications to keep
  static const int maxNotificationsToKeep = 100;

  // ============================================
  // CHAT
  // ============================================

  /// Max message length
  static const int maxMessageLength = 500;

  /// Max messages to load initially
  static const int initialMessagesToLoad = 50;

  /// Message pagination
  static const int messagesPaginationLimit = 20;

  // ============================================
  // SUPPORT
  // ============================================

  /// Support contact
  static const String supportEmail = 'support@trash2heal.com';
  static const String supportPhone = '+62 812-3456-7890';
  static const String supportWhatsApp = '6281234567890';

  /// Social media
  static const String instagramUrl = 'https://instagram.com/trash2heal';
  static const String facebookUrl = 'https://facebook.com/trash2heal';
  static const String twitterUrl = 'https://twitter.com/trash2heal';

  /// Website
  static const String websiteUrl = 'https://trash2heal.com';
  static const String termsUrl = 'https://trash2heal.com/terms';
  static const String privacyUrl = 'https://trash2heal.com/privacy';

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Calculate estimated points from quantities
  static double calculateEstimatedPoints(Map<String, int> quantities,
      [Map<String, double>? customRates]) {
    double totalPoints = 0;
    final rates = customRates ?? defaultPointRates;

    quantities.forEach((category, quantity) {
      final pointRate = rates[category] ?? 0;
      final avgWeight = defaultAvgWeightKg[category] ?? 0;
      totalPoints += quantity * avgWeight * pointRate;
    });

    return totalPoints;
  }

  /// Calculate estimated weight from quantities
  static double calculateEstimatedWeight(Map<String, int> quantities) {
    double totalWeight = 0;

    quantities.forEach((category, quantity) {
      final avgWeight = defaultAvgWeightKg[category] ?? 0;
      totalWeight += quantity * avgWeight;
    });

    return totalWeight;
  }

  /// Convert points to coupons
  static int pointsToCoupons(double points) {
    return (points / pointsToCouponRate).floor();
  }

  /// Convert points to balance (IDR)
  static double pointsToBalance(double points) {
    return (points / pointsToBalanceRate) * balanceValuePerPoint;
  }

  /// Convert coupons to points
  static double couponsToPoints(int coupons) {
    return coupons * pointsToCouponRate;
  }

  /// Convert balance to points
  static double balanceToPoints(double balance) {
    return (balance / balanceValuePerPoint) * pointsToBalanceRate;
  }

  /// Check if points are enough for coupon redemption
  static bool canRedeemCoupon(double points, int quantity) {
    final required = quantity * pointsToCouponRate;
    return points >= required && quantity <= maxCouponsPerRedemption;
  }

  /// Check if points are enough for balance redemption
  static bool canRedeemBalance(double points, double amount) {
    final required = balanceToPoints(amount);
    return points >= required &&
        required >= minPointsForBalance &&
        amount <= maxBalancePerRedemption;
  }
}
