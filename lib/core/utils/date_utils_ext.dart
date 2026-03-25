import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AppDateUtils {
  AppDateUtils._();

  // Formatters
  static final _dayName      = DateFormat('EEEE');        // "Monday"
  static final _dayShort     = DateFormat('EEE');         // "Mon"
  static final _monthShort   = DateFormat('MMM');         // "Mar"
  static final _monthLong    = DateFormat('MMMM');        // "March"
  static final _monthYear    = DateFormat('MMMM yyyy');   // "March 2026"
  static final _displayFull  = DateFormat('EEEE, MMMM d, yyyy'); // "Monday, March 13, 2026"
  static final _displayShort = DateFormat('d MMM yyyy');  // "13 Mar 2026"
  static final _numeric      = DateFormat('dd/MM/yyyy');  // "13/03/2026"
  static final _timeFormat   = DateFormat('h:mm a');      // "9:00 AM"

  // Display strings

  /// "Monday, March 13, 2026"
  static String displayFull(DateTime date) => _displayFull.format(date);

  /// "13 Mar 2026"
  static String displayShort(DateTime date) => _displayShort.format(date);

  /// "13/03/2026"
  static String numeric(DateTime date) => _numeric.format(date);

  /// "Monday"
  static String weekdayName(DateTime date) => _dayName.format(date);

  /// "Mon"
  static String weekdayShort(DateTime date) => _dayShort.format(date);

  /// "March"
  static String monthName(DateTime date) => _monthLong.format(date);

  /// "Mar"
  static String monthShort(DateTime date) => _monthShort.format(date);

  /// "March 2026"
  static String monthYear(DateTime date) => _monthYear.format(date);

  /// Day number as string: "13"
  static String dayNumber(DateTime date) => date.day.toString();

  /// "9:00 AM"
  static String timeString(DateTime date) => _timeFormat.format(date);

  // Relative time

  static String relativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60)   return 'just now';
    if (diff.inMinutes < 60)   return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    if (diff.inHours < 24)     return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    if (diff.inDays == 1)      return 'yesterday';
    if (diff.inDays < 7)       return '${diff.inDays} days ago';
    if (diff.inDays < 14)      return '1 week ago';
    if (diff.inDays < 30)      return '${(diff.inDays / 7).floor()} weeks ago';
    if (diff.inDays < 60)      return '1 month ago';
    if (diff.inDays < 365)     return '${(diff.inDays / 30).floor()} months ago';

    return displayShort(date);
  }

  /// Compact relative time for tight spaces: "2h", "3d", "1w", "2mo"
  static String relativeTimeCompact(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60)  return 'now';
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m';
    if (diff.inHours < 24)    return '${diff.inHours}h';
    if (diff.inDays < 7)      return '${diff.inDays}d';
    if (diff.inDays < 30)     return '${(diff.inDays / 7).floor()}w';
    if (diff.inDays < 365)    return '${(diff.inDays / 30).floor()}mo';

    return '${(diff.inDays / 365).floor()}y';
  }

  //  Comparison helpers

  /// True if [date] is today
    static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// True if [a] and [b] fall on the same calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// True if [date] is in the same month and year as [month].
  static bool isSameMonth(DateTime date, DateTime month) {
    return date.year == month.year && date.month == month.month;
  }

  /// True if [date] falls on a weekend (Saturday or Sunday).
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday;
  }

  /// True if [date] is before today
  static bool isPast(DateTime date) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.isBefore(todayOnly);
  }

  //  Calendar helpers

  /// Returns the first day of the month for [date].
  static DateTime firstDayOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1);

  /// Returns the last day of the month for [date].
  static DateTime lastDayOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0);

  /// Number of days in the month of [date].
  static int daysInMonth(DateTime date) =>
      DateUtils.getDaysInMonth(date.year, date.month);

  /// Returns the previous month relative to [date].
  static DateTime previousMonth(DateTime date) =>
      DateTime(date.year, date.month - 1);

  /// Returns the next month relative to [date].
  static DateTime nextMonth(DateTime date) =>
      DateTime(date.year, date.month + 1);

  /// Returns a list of all dates in the week containing [date].
  /// Week starts on Saturday.
  static List<DateTime> weekContaining(DateTime date) {
    final saturday = date.subtract(Duration(days: (date.weekday + 1) % 7));
    return List.generate(7, (i) => saturday.add(Duration(days: i)));
  }

  //  Schedule-specific helpers

  static String scheduleDay(DateTime date) => _dayName.format(date);

  static String formatTimeOfDay(int hour, int minute) {
    final period = hour < 12 ? 'AM' : 'PM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  static List<int>? parseTimeString(String time) {
    try {
      final dt = DateFormat('h:mm a').parse(time);
      return [dt.hour, dt.minute];
    } catch (_) {
      return null;
    }
  }
}