/// Admin dashboard value constants (spacing, sizing, etc.)
class AdminValues {
  AdminValues._();

  /// Spacing
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2xl = 48.0;
  static const double space3xl = 64.0;

  /// Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  /// Icon Sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  static const double icon2xl = 64.0;

  /// Font Sizes
  static const double fontXs = 12.0;
  static const double fontSm = 14.0;
  static const double fontMd = 16.0;
  static const double fontLg = 18.0;
  static const double fontXl = 20.0;
  static const double font2xl = 24.0;
  static const double font3xl = 30.0;
  static const double font4xl = 36.0;

  /// Button Heights
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;

  /// Input Heights
  static const double inputHeightSm = 36.0;
  static const double inputHeightMd = 44.0;
  static const double inputHeightLg = 52.0;

  /// Avatar Sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 48.0;
  static const double avatarXl = 64.0;

  /// Card Elevations
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  /// Border Widths
  static const double borderThin = 1.0;
  static const double borderMedium = 2.0;
  static const double borderThick = 3.0;

  /// Opacity
  static const double opacityDisabled = 0.4;
  static const double opacityHover = 0.8;
  static const double opacityPressed = 0.6;
  static const double opacityOverlay = 0.5;

  /// Layout
  static const double maxContentWidth = 1400.0;
  static const double sidebarWidth = 280.0;
  static const double collapsedSidebarWidth = 80.0;
  static const double topbarHeight = 64.0;
  static const double bottombarHeight = 56.0;

  /// Breakpoints
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 1024.0;
  static const double breakpointDesktop = 1440.0;

  /// Animation Durations (milliseconds)
  static const int animationFast = 150;
  static const int animationNormal = 300;
  static const int animationSlow = 500;

  /// Form
  static const double formFieldSpacing = 16.0;
  static const double formSectionSpacing = 32.0;
  static const double formMaxWidth = 600.0;

  /// Table
  static const double tableRowHeight = 56.0;
  static const double tableHeaderHeight = 48.0;
  static const double tableCellPadding = 16.0;
  static const double tableMinWidth = 800.0;

  /// Modal
  static const double modalMaxWidth = 600.0;
  static const double modalMaxHeight = 800.0;
  static const double modalPadding = 24.0;

  /// Card
  static const double cardPadding = 16.0;
  static const double cardPaddingLg = 24.0;
  static const double cardMaxWidth = 400.0;

  /// Image
  static const double imageMaxSize = 5 * 1024 * 1024; // 5MB
  static const double thumbnailSize = 64.0;
  static const double previewSize = 200.0;

  /// List
  static const double listItemHeight = 72.0;
  static const double listItemHeightSm = 56.0;
  static const double listTilePadding = 16.0;

  /// Grid
  static const double gridSpacing = 16.0;
  static const double gridCrossAxisSpacing = 16.0;
  static const double gridMainAxisSpacing = 16.0;

  /// Chart
  static const double chartHeight = 300.0;
  static const double chartMinWidth = 400.0;
  static const double chartPadding = 16.0;

  /// Badge
  static const double badgeSize = 20.0;
  static const double badgePadding = 6.0;

  /// Tooltip
  static const double tooltipMaxWidth = 200.0;
  static const double tooltipPadding = 8.0;

  /// Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  /// Snackbar
  static const double snackbarMaxWidth = 600.0;
  static const int snackbarDuration = 3000; // milliseconds

  /// Loading
  static const double loadingSize = 40.0;
  static const double loadingSizeSm = 20.0;
  static const double loadingSizeLg = 60.0;

  /// Search
  static const double searchBarHeight = 48.0;
  static const double searchBarMaxWidth = 400.0;

  /// Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  static const List<int> pageSizeOptions = [10, 25, 50, 100];

  /// Debounce (milliseconds)
  static const int debounceSearch = 500;
  static const int debounceAutoSave = 2000;

  /// Max Lengths
  static const int maxLengthShort = 50;
  static const int maxLengthMedium = 100;
  static const int maxLengthLong = 500;
  static const int maxLengthDescription = 1000;

  /// Min Lengths
  static const int minLengthPassword = 6;
  static const int minLengthUsername = 3;
  static const int minLengthSearch = 2;

  /// Numeric Limits
  static const int minPoints = 0;
  static const int maxPoints = 1000000;
  static const double minPrice = 0.0;
  static const double maxPrice = 10000000.0;
  static const int minCapacity = 1;
  static const int maxCapacity = 1000;
}
