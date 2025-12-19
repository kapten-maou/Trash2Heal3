import 'package:intl/intl.dart';

/// Date and time utility functions
class DateTimeUtils {
  DateTimeUtils._();

  // Date Formatters
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, HH:mm');
  static final DateFormat _fullDateTimeFormat =
      DateFormat('EEEE, dd MMMM yyyy HH:mm');
  static final DateFormat _shortDateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat _dayMonthFormat = DateFormat('dd MMM');

  /// Format date to readable string
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return _dateFormat.format(date);
  }

  /// Format time to readable string
  static String formatTime(DateTime? date) {
    if (date == null) return '-';
    return _timeFormat.format(date);
  }

  /// Format datetime to readable string
  static String formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return _dateTimeFormat.format(date);
  }

  /// Format datetime to full readable string
  static String formatFullDateTime(DateTime? date) {
    if (date == null) return '-';
    return _fullDateTimeFormat.format(date);
  }

  /// Format date to short format (dd/MM/yyyy)
  static String formatShortDate(DateTime? date) {
    if (date == null) return '-';
    return _shortDateFormat.format(date);
  }

  /// Format to month and year
  static String formatMonthYear(DateTime? date) {
    if (date == null) return '-';
    return _monthYearFormat.format(date);
  }

  /// Format to day and month
  static String formatDayMonth(DateTime? date) {
    if (date == null) return '-';
    return _dayMonthFormat.format(date);
  }

  /// Get relative time (e.g., "2 hours ago", "yesterday")
  static String getRelativeTime(DateTime? date) {
    if (date == null) return '-';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      if (days == 1) return 'yesterday';
      return '$days days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime? date) {
    if (date == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is in current week
  static bool isThisWeek(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  /// Check if date is in current month
  static bool isThisMonth(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Check if date is in current year
  static bool isThisYear(DateTime? date) {
    if (date == null) return false;
    return date.year == DateTime.now().year;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Get start of year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Get end of year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  /// Get days in month
  static int daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// Get week number in year
  static int weekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(startOfYear).inDays;
    return (days / 7).ceil();
  }

  /// Parse date from string
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get age from birthdate
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Get duration between two dates
  static String getDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);

    if (duration.inDays > 0) {
      return '${duration.inDays} ${duration.inDays == 1 ? 'day' : 'days'}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ${duration.inHours == 1 ? 'hour' : 'hours'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} ${duration.inMinutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return '${duration.inSeconds} seconds';
    }
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Add working days (skip weekends)
  static DateTime addWorkingDays(DateTime date, int days) {
    var result = date;
    var daysToAdd = days;

    while (daysToAdd > 0) {
      result = result.add(const Duration(days: 1));
      // Skip Saturday (6) and Sunday (7)
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        daysToAdd--;
      }
    }

    return result;
  }

  /// Get list of dates between two dates
  static List<DateTime> getDateRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = startOfDay(start);
    final endDay = startOfDay(end);

    while (current.isBefore(endDay) || current.isAtSameMomentAs(endDay)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }
}
