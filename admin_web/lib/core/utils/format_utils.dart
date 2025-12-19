import 'package:intl/intl.dart';

/// Format utility functions
class FormatUtils {
  FormatUtils._();

  // Number Formatters
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final NumberFormat _decimalFormat =
      NumberFormat.decimalPattern('id_ID');
  static final NumberFormat _percentFormat =
      NumberFormat.percentPattern('id_ID');
  static final NumberFormat _compactFormat =
      NumberFormat.compact(locale: 'id_ID');

  /// Format number to currency (Indonesian Rupiah)
  static String formatCurrency(dynamic value) {
    if (value == null) return 'Rp 0';
    if (value is String) {
      value = double.tryParse(value) ?? 0;
    }
    return _currencyFormat.format(value);
  }

  /// Format number with thousand separators
  static String formatNumber(dynamic value) {
    if (value == null) return '0';
    if (value is String) {
      value = double.tryParse(value) ?? 0;
    }
    return _decimalFormat.format(value);
  }

  /// Format number to percentage
  static String formatPercent(dynamic value, {int decimals = 1}) {
    if (value == null) return '0%';
    if (value is String) {
      value = double.tryParse(value) ?? 0;
    }
    final percentage = (value is int ? value.toDouble() : value) / 100;
    return NumberFormat.percentPattern('id_ID')
        .format(percentage)
        .replaceAll(',', '.');
  }

  /// Format number to compact form (1.2K, 1.5M, etc)
  static String formatCompact(dynamic value) {
    if (value == null) return '0';
    if (value is String) {
      value = double.tryParse(value) ?? 0;
    }
    return _compactFormat.format(value);
  }

  /// Format phone number (Indonesia)
  static String formatPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return '-';

    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 10) return phone;

    // Format: 0812-3456-7890
    if (digits.startsWith('0')) {
      return '${digits.substring(0, 4)}-${digits.substring(4, 8)}-${digits.substring(8)}';
    }
    // Format: +62 812-3456-7890
    else if (digits.startsWith('62')) {
      return '+62 ${digits.substring(2, 5)}-${digits.substring(5, 9)}-${digits.substring(9)}';
    }

    return phone;
  }

  /// Format file size (bytes to human readable)
  static String formatFileSize(int bytes) {
    if (bytes < 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format duration (seconds to human readable)
  static String formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      return '$minutes min';
    } else if (seconds < 86400) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      return '$hours h ${minutes > 0 ? '$minutes m' : ''}';
    } else {
      final days = seconds ~/ 86400;
      return '$days day${days > 1 ? 's' : ''}';
    }
  }

  /// Capitalize first letter
  static String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Title case (capitalize each word)
  static String titleCase(String? text) {
    if (text == null || text.isEmpty) return '';
    return text
        .split(' ')
        .map((word) => word.isEmpty ? '' : capitalize(word))
        .join(' ');
  }

  /// Upper case
  static String upperCase(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.toUpperCase();
  }

  /// Lower case
  static String lowerCase(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.toLowerCase();
  }

  /// Truncate text with ellipsis
  static String truncate(String? text, int maxLength, {String suffix = '...'}) {
    if (text == null || text.isEmpty) return '';
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + suffix;
  }

  /// Format weight (kg)
  static String formatWeight(dynamic value) {
    if (value == null) return '0 kg';
    if (value is String) {
      value = double.tryParse(value) ?? 0;
    }
    return '${formatNumber(value)} kg';
  }

  /// Format points
  static String formatPoints(dynamic value) {
    if (value == null) return '0 pts';
    if (value is String) {
      value = int.tryParse(value) ?? 0;
    }
    return '${formatNumber(value)} pts';
  }

  /// Format ordinal number (1st, 2nd, 3rd, etc)
  static String formatOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  /// Format status to readable text
  static String formatStatus(String? status) {
    if (status == null || status.isEmpty) return '-';
    return status.split('_').map((word) => capitalize(word)).join(' ');
  }

  /// Format role to readable text
  static String formatRole(String? role) {
    if (role == null || role.isEmpty) return '-';
    switch (role.toLowerCase()) {
      case 'super_admin':
        return 'Super Admin';
      case 'admin':
        return 'Admin';
      case 'courier':
        return 'Courier';
      case 'user':
        return 'User';
      default:
        return capitalize(role);
    }
  }

  /// Format address (truncate if too long)
  static String formatAddress(String? address, {int maxLength = 50}) {
    if (address == null || address.isEmpty) return '-';
    return truncate(address, maxLength);
  }

  /// Format email (mask for privacy)
  static String maskEmail(String? email) {
    if (email == null || email.isEmpty) return '-';
    if (!email.contains('@')) return email;

    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email;

    final maskedUsername =
        '${username.substring(0, 2)}${'*' * (username.length - 2)}';
    return '$maskedUsername@$domain';
  }

  /// Format phone (mask for privacy)
  static String maskPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '-';
    if (phone.length <= 4) return phone;

    final visible = phone.substring(0, 4);
    final hidden = '*' * (phone.length - 4);
    return '$visible$hidden';
  }

  /// Remove HTML tags
  static String stripHtml(String? html) {
    if (html == null || html.isEmpty) return '';
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Format list to comma-separated string
  static String formatList(List<String>? items, {String separator = ', '}) {
    if (items == null || items.isEmpty) return '-';
    return items.join(separator);
  }

  /// Format boolean to Yes/No
  static String formatBoolean(bool? value,
      {String yes = 'Yes', String no = 'No'}) {
    if (value == null) return '-';
    return value ? yes : no;
  }

  /// Format map to string
  static String formatMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return '-';
    return map.entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }

  /// Parse currency string to number
  static double? parseCurrency(String? text) {
    if (text == null || text.isEmpty) return null;
    // Remove currency symbol and thousand separators
    final cleaned = text.replaceAll(RegExp(r'[^\d,.]'), '');
    return double.tryParse(cleaned.replaceAll(',', '.'));
  }

  /// Parse number string to double
  static double? parseNumber(String? text) {
    if (text == null || text.isEmpty) return null;
    return double.tryParse(text.replaceAll(',', '.'));
  }

  /// Parse number string to int
  static int? parseInt(String? text) {
    if (text == null || text.isEmpty) return null;
    return int.tryParse(text.replaceAll(RegExp(r'\D'), ''));
  }
}
