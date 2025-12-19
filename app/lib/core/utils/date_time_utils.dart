import 'package:intl/intl.dart';
import '../constants/app_values.dart';

/// Date Time Utility Functions
class DateTimeUtils {
  DateTimeUtils._();

  // ============================================
  // FORMATTERS
  // ============================================

  /// Format date to short format (dd MMM yyyy)
  static String formatDateShort(DateTime date) {
    return DateFormat(AppValues.dateFormatShort, 'id').format(date);
  }

  /// Format date to long format (EEEE, dd MMMM yyyy)
  static String formatDateLong(DateTime date) {
    return DateFormat(AppValues.dateFormatLong, 'id').format(date);
  }

  /// Format date to full format (dd MMMM yyyy)
  static String formatDateFull(DateTime date) {
    return DateFormat(AppValues.dateFormatFull, 'id').format(date);
  }

  /// Format time (HH:mm)
  static String formatTime(DateTime time) {
    return DateFormat(AppValues.timeFormat).format(time);
  }

  /// Format datetime (dd MMM yyyy, HH:mm)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppValues.dateTimeFormat, 'id').format(dateTime);
  }

  /// Format relative time (e.g., "2 jam yang lalu")
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }

  /// Format time range (08:00 - 10:00)
  static String formatTimeRange(String startTime, String endTime) {
    return '$startTime - $endTime';
  }

  /// Format countdown (e.g., "2 hari 3 jam lagi")
  static String formatCountdown(DateTime targetDate) {
    final now = DateTime.now();
    final difference = targetDate.difference(now);

    if (difference.isNegative) {
      return 'Sudah lewat';
    }

    if (difference.inDays > 0) {
      if (difference.inHours % 24 > 0) {
        return '${difference.inDays} hari ${difference.inHours % 24} jam lagi';
      }
      return '${difference.inDays} hari lagi';
    } else if (difference.inHours > 0) {
      if (difference.inMinutes % 60 > 0) {
        return '${difference.inHours} jam ${difference.inMinutes % 60} menit lagi';
      }
      return '${difference.inHours} jam lagi';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lagi';
    } else {
      return '${difference.inSeconds} detik lagi';
    }
  }

  // ============================================
  // GREETING
  // ============================================

  /// Get greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  // ============================================
  // CALCULATIONS
  // ============================================

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Check if date is in current week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is in current month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Check if date is in current year
  static bool isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  /// Get days between two dates
  static int daysBetween(DateTime start, DateTime end) {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    return endDate.difference(startDate).inDays;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Get start of week
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Get end of week
  static DateTime endOfWeek(DateTime date) {
    return startOfWeek(date)
        .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }

  /// Get start of year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Get end of year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59);
  }

  // ============================================
  // PARSING
  // ============================================

  /// Parse date from string (dd/MM/yyyy)
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parse time from string (HH:mm)
  static DateTime? parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  /// Parse datetime from ISO string
  static DateTime? parseIso(String isoString) {
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // BUSINESS LOGIC
  // ============================================

  /// Check if date is within business hours
  static bool isWithinBusinessHours(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final timeInMinutes = hour * 60 + minute;

    final startParts = AppValues.businessHoursStart.split(':');
    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);

    final endParts = AppValues.businessHoursEnd.split(':');
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    return timeInMinutes >= startMinutes && timeInMinutes <= endMinutes;
  }

  /// Check if date is a weekend
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  /// Get next business day
  static DateTime getNextBusinessDay(DateTime date) {
    DateTime nextDay = date.add(const Duration(days: 1));
    while (isWeekend(nextDay)) {
      nextDay = nextDay.add(const Duration(days: 1));
    }
    return nextDay;
  }

  /// Get available pickup dates (next 7 days, excluding weekends)
  static List<DateTime> getAvailablePickupDates() {
    final dates = <DateTime>[];
    DateTime current =
        DateTime.now().add(const Duration(days: 1)); // Start from tomorrow

    while (dates.length < 7) {
      if (!isWeekend(current)) {
        dates.add(startOfDay(current));
      }
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Format date for display in list (Today, Yesterday, or date)
  static String formatForList(DateTime date) {
    if (isToday(date)) {
      return 'Hari ini, ${formatTime(date)}';
    } else if (isYesterday(date)) {
      return 'Kemarin, ${formatTime(date)}';
    } else if (isThisWeek(date)) {
      return DateFormat('EEEE, HH:mm', 'id').format(date);
    } else if (isThisYear(date)) {
      return formatDateTime(date);
    } else {
      return formatDateTime(date);
    }
  }

  /// Check if can reschedule (H-1 rule)
  static bool canReschedule(DateTime pickupDate) {
    final now = DateTime.now();
    final daysBefore = pickupDate.difference(now).inDays;
    return daysBefore >= AppValues.maxRescheduleDaysBefore;
  }

  /// Get age from date of birth
  static int getAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}
