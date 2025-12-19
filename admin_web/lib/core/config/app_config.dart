/// Admin dashboard application configuration
class AppConfig {
  // Private constructor
  AppConfig._();

  /// App information
  static const String appName = 'Trash2Heal Admin';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Waste Management Admin Dashboard';

  /// API Configuration
  static const String apiBaseUrl =
      'https://us-central1-trash2heal.cloudfunctions.net';
  static const Duration apiTimeout = Duration(seconds: 30);

  /// Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  static const List<int> pageSizeOptions = [10, 25, 50, 100];

  /// File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocTypes = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx'
  ];

  /// Date & Time Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd MMM yyyy, HH:mm';
  static const String fullDateTimeFormat = 'EEEE, dd MMMM yyyy HH:mm:ss';

  /// Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Sidebar
  static const double sidebarWidth = 280;
  static const double collapsedSidebarWidth = 80;

  /// Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  /// Debounce Durations
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration autoSaveDebounce = Duration(seconds: 2);

  /// Cache Durations
  static const Duration shortCache = Duration(minutes: 5);
  static const Duration mediumCache = Duration(minutes: 30);
  static const Duration longCache = Duration(hours: 1);

  /// Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

  /// Point System
  static const int defaultPointsPerKg = 100;
  static const int minPointsPerKg = 10;
  static const int maxPointsPerKg = 1000;

  /// Pickup System
  static const int maxPickupDaysInAdvance = 30;
  static const int minSlotDuration = 30; // minutes
  static const int maxSlotCapacity = 50;

  /// Membership
  static const List<String> membershipTiers = [
    'Free',
    'Silver',
    'Gold',
    'Platinum'
  ];

  /// Export Limits
  static const int maxExportRows = 10000;

  /// Notification Settings
  static const int maxNotificationsToShow = 50;
  static const Duration notificationDuration = Duration(seconds: 5);

  /// Chart Settings
  static const int defaultChartDataPoints = 30;
  static const int maxChartDataPoints = 90;

  /// Session
  static const Duration sessionTimeout = Duration(hours: 8);
  static const Duration refreshTokenBefore = Duration(minutes: 5);

  /// Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableDebugMode = false;

  /// Environment Detection
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  static bool get isDevelopment => !isProduction;

  /// Support
  static const String supportEmail = 'admin@trash2heal.com';
  static const String supportPhone = '+62-xxx-xxxx-xxxx';
  static const String documentationUrl = 'https://docs.trash2heal.com';

  /// Social Media (for footer or about section)
  static const String websiteUrl = 'https://trash2heal.com';
  static const String facebookUrl = 'https://facebook.com/trash2heal';
  static const String instagramUrl = 'https://instagram.com/trash2heal';
  static const String twitterUrl = 'https://twitter.com/trash2heal';
}
