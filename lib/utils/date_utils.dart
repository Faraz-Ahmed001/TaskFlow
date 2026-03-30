import 'package:intl/intl.dart';

class AppDateUtils {
  // Format date as "Jan 15, 2024"
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format date as "15 Jan"
  static String formatShortDate(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  // Format time as "2:30 PM"
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  // Format date and time as "Jan 15, 2024 at 2:30 PM"
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy \'at\' h:mm a').format(date);
  }

  // Get relative date string (Today, Tomorrow, Yesterday, or formatted date)
  static String getRelativeDateString(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final difference = dateOnly.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 1 && difference <= 7) {
      return DateFormat('EEEE').format(date); // Day name
    } else {
      return formatDate(date);
    }
  }

  // Get due date display string
  static String getDueDateDisplay(DateTime? dueDate, bool isCompleted) {
    if (dueDate == null) return 'No due date';

    if (isCompleted) {
      return formatShortDate(dueDate);
    }

    final now = DateTime.now();
    final isOverdue = now.isAfter(dueDate);

    if (isOverdue) {
      final daysOverdue = now.difference(dueDate).inDays;
      if (daysOverdue == 0) {
        return 'Due today';
      } else if (daysOverdue == 1) {
        return 'Overdue by 1 day';
      } else {
        return 'Overdue by $daysOverdue days';
      }
    }

    return getRelativeDateString(dueDate);
  }

  // Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Get start of day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}
