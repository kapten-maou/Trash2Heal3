import 'package:flutter/material.dart';

/// Admin dashboard color constants
class AdminColors {
  AdminColors._();

  /// Primary Colors
  static const Color primary = Color(0xFF2563EB); // Blue
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF3B82F6);

  /// Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Green
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF34D399);

  /// Accent Colors
  static const Color accent = Color(0xFFF59E0B); // Orange
  static const Color accentDark = Color(0xFFD97706);
  static const Color accentLight = Color(0xFFFBBF24);

  /// Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  /// Status Backgrounds
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color infoBg = Color(0xFFDBEAFE);

  /// Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  /// Background Colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFFEFEFEF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFF3F4F6);

  /// Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  /// Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFFD1D5DB);
  static const Color divider = Color(0xFFE5E7EB);

  /// Feature Colors
  static const Color pickup = Color(0xFFF59E0B); // Orange
  static const Color event = Color(0xFF8B5CF6); // Purple
  static const Color membership = Color(0xFFEC4899); // Pink
  static const Color transaction = Color(0xFF10B981); // Green
  static const Color user = Color(0xFF3B82F6); // Blue
  static const Color courier = Color(0xFF6366F1); // Indigo

  /// Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF2563EB), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Orange
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Cyan
    Color(0xFF84CC16), // Lime
  ];

  /// Role Colors
  static const Color roleAdmin = Color(0xFFEF4444); // Red
  static const Color roleSuperAdmin = Color(0xFF7C3AED); // Purple
  static const Color roleUser = Color(0xFF3B82F6); // Blue
  static const Color roleCourier = Color(0xFF10B981); // Green

  /// Sidebar Colors
  static const Color sidebarBg = Color(0xFF1F2937);
  static const Color sidebarActive = Color(0xFF3B82F6);
  static const Color sidebarHover = Color(0xFF374151);
  static const Color sidebarText = Color(0xFFE5E7EB);
  static const Color sidebarTextActive = Color(0xFFFFFFFF);

  /// Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  /// Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  /// Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
  );

  /// Status-based Color Getter
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
      case 'success':
      case 'approved':
      case 'confirmed':
        return success;
      case 'pending':
      case 'processing':
      case 'in_progress':
        return warning;
      case 'cancelled':
      case 'rejected':
      case 'failed':
      case 'error':
        return error;
      case 'inactive':
      case 'suspended':
      case 'disabled':
        return grey500;
      default:
        return info;
    }
  }

  /// Role-based Color Getter
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
        return roleSuperAdmin;
      case 'admin':
        return roleAdmin;
      case 'courier':
        return roleCourier;
      case 'user':
        return roleUser;
      default:
        return grey500;
    }
  }
}
