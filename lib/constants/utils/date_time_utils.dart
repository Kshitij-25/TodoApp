import 'package:flutter/foundation.dart' show immutable;
import 'package:intl/intl.dart';

@immutable
class DateTimeUtils {
  // Format date to 'yyyy-MM-dd' format
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  // Format the day (e.g., Monday)
  static String formatDay(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime);
  }

  // Format time to 'HH:mm' format
  static String formatTime(DateTime time) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(time);
  }

  // Format date and time to 'yyyy-MM-dd HH:mm' format
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  // Parse date from 'yyyy-MM-dd' format
  static DateTime parseDate(String dateStr) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.parse(dateStr);
  }

  // Parse time from 'HH:mm' format
  static DateTime parseTime(String timeStr) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.parse(timeStr);
  }

  // Parse date and time from 'yyyy-MM-dd HH:mm' format
  static DateTime parseDateTime(String dateTimeStr) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.parse(dateTimeStr);
  }

  // Calculate the time elapsed from a given date
  static String timeAgo(DateTime dateTime) {
    Duration diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 365) {
      int years = (diff.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (diff.inDays > 30) {
      int months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (diff.inDays > 7) {
      int weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }
}
