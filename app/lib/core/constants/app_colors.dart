import 'package:flutter/material.dart';

/// App Color Palette - Eco/Green Theme
class AppColors {
  AppColors._();

  // Primary Colors (Green/Eco)
  static const Color primary = Color(0xFF2E7D32); // Dark Green
  static const Color primaryLight = Color(0xFF60AD5E); // Light Green
  static const Color primaryDark = Color(0xFF005005); // Very Dark Green
  static const Color primaryContainer = Color(0xFFB8E6B8); // Pale Green

  // Secondary Colors (Earth Tones)
  static const Color secondary = Color(0xFF8D6E63); // Brown
  static const Color secondaryLight = Color(0xFFBE9C91);
  static const Color secondaryDark = Color(0xFF5F4339);
  static const Color secondaryContainer = Color(0xFFEFDEDB);

  // Accent Colors
  static const Color accent = Color(0xFF66BB6A); // Vibrant Green
  static const Color accentOrange = Color(0xFFFF9800); // Orange for alerts
  static const Color accentBlue = Color(0xFF2196F3); // Blue for info

  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFFC107); // Amber
  static const Color error = Color(0xFFF44336); // Red
  static const Color info = Color(0xFF2196F3); // Blue

  // Neutral Colors
  static const Color background = Color(0xFFF5F5F5); // Light Gray
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFEEEEEE); // Off-white

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Almost Black
  static const Color textSecondary = Color(0xFF757575); // Gray
  static const Color textDisabled = Color(0xFFBDBDBD); // Light Gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White
  static const Color textOnSecondary = Color(0xFFFFFFFF); // White

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFFBDBDBD);

  // Shadow
  static const Color shadow = Color(0x1A000000); // 10% black

  // Gradient Colors
  static const List<Color> gradientPrimary = [
    Color(0xFF2E7D32),
    Color(0xFF66BB6A),
  ];

  static const List<Color> gradientSecondary = [
    Color(0xFF8D6E63),
    Color(0xFFBE9C91),
  ];

  static const List<Color> gradientAccent = [
    Color(0xFF66BB6A),
    Color(0xFF4CAF50),
  ];

  // Waste Category Colors (for icons/cards)
  static const Color categoryPlastic = Color(0xFF3F51B5); // Indigo
  static const Color categoryGlass = Color(0xFF00BCD4); // Cyan
  static const Color categoryCan = Color(0xFF9E9E9E); // Gray
  static const Color categoryCardboard = Color(0xFF795548); // Brown
  static const Color categoryFabric = Color(0xFFE91E63); // Pink
  static const Color categoryCeramic = Color(0xFFFF5722); // Deep Orange

  // Points & Rewards
  static const Color pointsGold = Color(0xFFFFD700); // Gold
  static const Color pointsSilver = Color(0xFFC0C0C0); // Silver
  static const Color pointsBronze = Color(0xFFCD7F32); // Bronze

  // Membership Tiers
  static const Color memberBasic = Color(0xFF9E9E9E); // Gray
  static const Color memberSilver = Color(0xFFC0C0C0); // Silver
  static const Color memberGold = Color(0xFFFFD700); // Gold
  static const Color memberPlatinum = Color(0xFFE5E4E2); // Platinum

  // Chart Colors (for statistics)
  static const List<Color> chartColors = [
    Color(0xFF2E7D32), // Green
    Color(0xFF66BB6A), // Light Green
    Color(0xFF8D6E63), // Brown
    Color(0xFFFF9800), // Orange
    Color(0xFF2196F3), // Blue
    Color(0xFFE91E63), // Pink
  ];

  // Status Badge Colors
  static const Color statusActive = Color(0xFF4CAF50);
  static const Color statusPending = Color(0xFFFFC107);
  static const Color statusCompleted = Color(0xFF2E7D32);
  static const Color statusCanceled = Color(0xFFF44336);
  static const Color statusExpired = Color(0xFF9E9E9E);

  // Overlay Colors
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x33000000); // 20% black

  // Special
  static const Color transparent = Color(0x00000000);
  static const Color divider = Color(0x1F000000); // 12% black

  // Helper: Get color for waste category
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'plastic':
      case 'plastik':
        return categoryPlastic;
      case 'glass':
      case 'kaca':
        return categoryGlass;
      case 'can':
      case 'kaleng':
        return categoryCan;
      case 'cardboard':
      case 'kardus':
        return categoryCardboard;
      case 'fabric':
      case 'kain':
        return categoryFabric;
      case 'ceramic':
      case 'ceramicstone':
      case 'keramik':
        return categoryCeramic;
      default:
        return primary;
    }
  }

  // Helper: Get status color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'aktif':
      case 'approved':
        return statusActive;
      case 'pending':
      case 'requested':
      case 'diproses':
        return statusPending;
      case 'completed':
      case 'done':
      case 'selesai':
        return statusCompleted;
      case 'canceled':
      case 'cancelled':
      case 'dibatalkan':
        return statusCanceled;
      case 'expired':
      case 'kadaluarsa':
        return statusExpired;
      default:
        return textSecondary;
    }
  }

  // Helper: Get membership tier color
  static Color getMembershipColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'gold':
      case 'emas':
        return memberGold;
      case 'silver':
      case 'perak':
        return memberSilver;
      case 'platinum':
        return memberPlatinum;
      case 'basic':
      case 'dasar':
      default:
        return memberBasic;
    }
  }
}
