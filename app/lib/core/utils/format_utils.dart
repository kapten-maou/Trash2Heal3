import 'package:intl/intl.dart';

/// Formatting Utility Functions
class FormatUtils {
  FormatUtils._();

  // ============================================
  // CURRENCY
  // ============================================

  /// Format number to IDR currency
  static String formatCurrency(double amount, {bool showSymbol = true}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: showSymbol ? 'Rp ' : '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format number to IDR currency (compact)
  static String formatCurrencyCompact(double amount) {
    if (amount >= 1000000000) {
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}Jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return formatCurrency(amount);
    }
  }

  // ============================================
  // NUMBER
  // ============================================

  /// Format number with thousand separator
  static String formatNumber(num number) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(number);
  }

  /// Format decimal number
  static String formatDecimal(double number, {int decimals = 2}) {
    return number.toStringAsFixed(decimals);
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 0}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Format number to compact format (K, M, B)
  static String formatNumberCompact(num number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  // ============================================
  // POINTS
  // ============================================

  /// Format points with suffix
  static String formatPoints(double points) {
    return '${formatNumber(points.toInt())} poin';
  }

  /// Format points compact
  static String formatPointsCompact(double points) {
    return '${formatNumberCompact(points.toInt())} poin';
  }

  // ============================================
  // WEIGHT
  // ============================================

  /// Format weight in kg
  static String formatWeight(double kg) {
    if (kg < 1) {
      return '${(kg * 1000).toInt()} gram';
    } else {
      return '${kg.toStringAsFixed(1)} kg';
    }
  }

  /// Format weight compact
  static String formatWeightCompact(double kg) {
    if (kg < 1) {
      return '${(kg * 1000).toInt()}g';
    } else {
      return '${kg.toStringAsFixed(1)}kg';
    }
  }

  // ============================================
  // PHONE
  // ============================================

  /// Format phone number (08xx-xxxx-xxxx)
  static String formatPhoneNumber(String phone) {
    // Remove all non-digits
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Format based on length
    if (cleaned.length >= 10) {
      if (cleaned.startsWith('62')) {
        // +62 format
        final withoutPrefix = cleaned.substring(2);
        return '+62 ${withoutPrefix.substring(0, 3)}-${withoutPrefix.substring(3, 7)}-${withoutPrefix.substring(7)}';
      } else if (cleaned.startsWith('0')) {
        // 08xx format
        return '${cleaned.substring(0, 4)}-${cleaned.substring(4, 8)}-${cleaned.substring(8)}';
      }
    }

    return phone; // Return original if can't format
  }

  /// Format phone for WhatsApp (62xxx format)
  static String formatPhoneForWhatsApp(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.startsWith('0')) {
      return '62${cleaned.substring(1)}';
    } else if (cleaned.startsWith('62')) {
      return cleaned;
    } else {
      return '62$cleaned';
    }
  }

  // ============================================
  // ACCOUNT NUMBER
  // ============================================

  /// Mask account number (show last 4 digits)
  static String maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;

    final visibleDigits = accountNumber.substring(accountNumber.length - 4);
    final maskedPart = '*' * (accountNumber.length - 4);
    return '$maskedPart$visibleDigits';
  }

  /// Format account number with spaces (1234 5678 9012 3456)
  static String formatAccountNumber(String accountNumber) {
    final cleaned = accountNumber.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleaned[i]);
    }

    return buffer.toString();
  }

  // ============================================
  // TEXT
  // ============================================

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Capitalize each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Remove extra spaces
  static String cleanSpaces(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // ============================================
  // EMAIL
  // ============================================

  /// Mask email (show first 3 and domain)
  static String maskEmail(String email) {
    if (!email.contains('@')) return email;

    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 3) {
      return '$username@$domain';
    }

    final visiblePart = username.substring(0, 3);
    final maskedPart = '*' * (username.length - 3);
    return '$visiblePart$maskedPart@$domain';
  }

  // ============================================
  // ADDRESS
  // ============================================

  /// Format full address
  static String formatAddress({
    String? street,
    String? district,
    String? city,
    String? province,
    String? postalCode,
  }) {
    final parts = <String>[];

    if (street != null && street.isNotEmpty) parts.add(street);
    if (district != null && district.isNotEmpty) parts.add(district);
    if (city != null && city.isNotEmpty) parts.add(city);
    if (province != null && province.isNotEmpty) parts.add(province);
    if (postalCode != null && postalCode.isNotEmpty) parts.add(postalCode);

    return parts.join(', ');
  }

  /// Format short address (city, province)
  static String formatAddressShort({
    String? city,
    String? province,
  }) {
    final parts = <String>[];

    if (city != null && city.isNotEmpty) parts.add(city);
    if (province != null && province.isNotEmpty) parts.add(province);

    return parts.join(', ');
  }

  // ============================================
  // FILE SIZE
  // ============================================

  /// Format file size (bytes to readable format)
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // ============================================
  // DISTANCE
  // ============================================

  /// Format distance (meters to readable format)
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toInt()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  // ============================================
  // VALIDATION
  // ============================================

  /// Check if string is valid email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  /// Check if string is valid phone
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^(^\+62|62|^08)(\d{8,11})$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[^\d+]'), ''));
  }

  /// Check if string is valid username
  static bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return usernameRegex.hasMatch(username) &&
        username.length >= 3 &&
        username.length <= 20;
  }

  // ============================================
  // PARSING
  // ============================================

  /// Parse currency string to double
  static double? parseCurrency(String currencyString) {
    try {
      // Remove Rp, spaces, dots
      final cleaned = currencyString
          .replaceAll('Rp', '')
          .replaceAll(' ', '')
          .replaceAll('.', '')
          .replaceAll(',', '.');

      return double.parse(cleaned);
    } catch (e) {
      return null;
    }
  }

  /// Parse number string to int
  static int? parseNumber(String numberString) {
    try {
      // Remove spaces and dots
      final cleaned = numberString
          .replaceAll(' ', '')
          .replaceAll('.', '')
          .replaceAll(',', '');

      return int.parse(cleaned);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // SPECIAL FORMATS
  // ============================================

  /// Format OTP (123-456)
  static String formatOTP(String otp) {
    if (otp.length != 6) return otp;
    return '${otp.substring(0, 3)}-${otp.substring(3)}';
  }

  /// Format coupon code (T2H-ABC123-456)
  static String formatCouponCode(String code) {
    return code.toUpperCase();
  }

  /// Format duration (seconds to readable)
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}j ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}d';
    } else {
      return '${secs}d';
    }
  }

  /// Format rating (4.5 / 5.0)
  static String formatRating(double rating, {int decimals = 1}) {
    return '${rating.toStringAsFixed(decimals)} / 5.0';
  }




    // ============================================
  // DATE & TIME
  // ============================================

  /// Format tanggal sederhana (dd/MM/yyyy)
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(pattern, 'id_ID');
    return formatter.format(date);
  }

  /// Format tanggal + jam (misal: 20 Nov 2025 • 14:30)
  static String formatDateTime(DateTime dateTime,
      {String pattern = 'dd MMM yyyy • HH:mm'}) {
    final formatter = DateFormat(pattern, 'id_ID');
    return formatter.format(dateTime);
  }

}
