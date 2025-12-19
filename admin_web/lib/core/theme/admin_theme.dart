import 'package:flutter/material.dart';

/// Admin dashboard theme configuration
class AdminTheme {
  // ==================== COLORS ====================

  // Primary Colors
  static const Color primaryColor = Color(0xFF2E7D32); // Dark Green
  static const Color primaryLight = Color(0xFF4CAF50); // Light Green
  static const Color primaryDark = Color(0xFF1B5E20); // Darker Green
  static const Color secondaryColor = Color(0xFF66BB6A);
  static const Color accentColor = Color(0xFF81C784);

  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFA726);
  static const Color errorColor = Color(0xFFEF5350);
  static const Color infoColor = Color(0xFF42A5F5);
  static const Color pendingColor = Color(0xFFFFB74D);

  // Neutral Colors - Light Theme
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;

  // Neutral Colors - Dark Theme
  static const Color backgroundColorDark = Color(0xFF121212);
  static const Color surfaceColorDark = Color(0xFF1E1E1E);
  static const Color cardColorDark = Color(0xFF2C2C2C);

  // Text Colors - Light Theme
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textHint = Color(0xFF9E9E9E);

  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Border & Divider
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color borderColorDark = Color(0xFF424242);

  // ==================== LIGHT THEME ====================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryLight,
        secondary: secondaryColor,
        secondaryContainer: accentColor,
        tertiary: accentColor,
        error: errorColor,
        background: backgroundColor, // ✅ FIXED: Use background instead
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textPrimary,
        onSurface: textPrimary,
        onError: Colors.white,
        outline: borderColor,
      ),

      scaffoldBackgroundColor: backgroundColor,

      // ==================== APP BAR ====================
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ==================== CARD ====================
      cardTheme: CardTheme(
        elevation: 0,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ==================== INPUT DECORATION ====================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,

        // Normal border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),

        // Enabled border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),

        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),

        // Error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),

        // Focused error border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),

        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: textHint),
        labelStyle: const TextStyle(color: textSecondary),
      ),

      // ==================== BUTTONS ====================

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Filled Button
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ==================== DATA TABLE ====================
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(backgroundColor), // ✅ FIXED
        dataRowColor: MaterialStateProperty.resolveWith((states) {
          // ✅ FIXED
          if (states.contains(MaterialState.selected)) {
            // ✅ FIXED
            return accentColor.withOpacity(0.1);
          }
          if (states.contains(MaterialState.hovered)) {
            // ✅ FIXED
            return backgroundColor;
          }
          return null;
        }),
        headingTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        dataTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 14,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // ==================== DIALOG ====================
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ==================== CHIP ====================
      chipTheme: ChipThemeData(
        backgroundColor: backgroundColor,
        selectedColor: accentColor,
        labelStyle: const TextStyle(fontSize: 14, color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: borderColor),
        ),
      ),

      // ==================== DIVIDER ====================
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      // ==================== LIST TILE ====================
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dense: false,
      ),

      // ==================== ICON ====================
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),
    );
  }

  // ==================== DARK THEME ====================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryLight,
        primaryContainer: primaryColor,
        secondary: secondaryColor,
        secondaryContainer: accentColor,
        tertiary: accentColor,
        error: errorColor,
        background: backgroundColorDark, // ✅ FIXED: Use background instead
        surface: surfaceColorDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textPrimaryDark,
        onSurface: textPrimaryDark,
        onError: Colors.white,
        outline: borderColorDark,
      ),
      scaffoldBackgroundColor: backgroundColorDark,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: surfaceColorDark,
        foregroundColor: textPrimaryDark,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: cardColorDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderColorDark, width: 1),
        ),
      ),
    );
  }

  // ==================== HELPER METHODS ====================

  /// Get status color based on status string
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
      case 'approved':
      case 'paid':
      case 'confirmed':
        return successColor;

      case 'pending':
      case 'upcoming':
      case 'assigned':
      case 'scheduled':
        return pendingColor;

      case 'cancelled':
      case 'rejected':
      case 'failed':
      case 'expired':
        return errorColor;

      case 'in_progress':
      case 'on_the_way':
      case 'arrived':
      case 'processing':
        return infoColor;

      default:
        return textSecondary;
    }
  }

  /// Get status chip widget
  static Widget statusChip(String status, {double? fontSize}) {
    final color = getStatusColor(status);
    final label = formatStatus(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Format status text (snake_case to Title Case)
  static String formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Get role badge color
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return errorColor;
      case 'courier':
        return infoColor;
      case 'user':
        return successColor;
      default:
        return textSecondary;
    }
  }

  /// Get role badge widget
  static Widget roleBadge(String role) {
    final color = getRoleColor(role);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ==================== SPACING CONSTANTS ====================

  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;
  static const double spacingXXXL = 64;

  // ==================== BORDER RADIUS CONSTANTS ====================

  static const double radiusXS = 4;
  static const double radiusS = 6;
  static const double radiusM = 8;
  static const double radiusL = 12;
  static const double radiusXL = 16;
  static const double radiusXXL = 24;

  // ==================== ELEVATION CONSTANTS ====================

  static const double elevationNone = 0;
  static const double elevationS = 2;
  static const double elevationM = 4;
  static const double elevationL = 8;
  static const double elevationXL = 16;
  static const double elevationXXL = 24;

  // ==================== BREAKPOINTS ====================

  static const double breakpointMobile = 600;
  static const double breakpointTablet = 900;
  static const double breakpointDesktop = 1200;
  static const double breakpointLargeDesktop = 1600;

  /// Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointMobile;
  }

  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointMobile && width < breakpointDesktop;
  }

  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointDesktop;
  }
}
