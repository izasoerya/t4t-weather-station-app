import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Formatting helpers that all render in the app's display timezone (UTC+7).
///
/// Supabase returns `TIMESTAMP WITH TIME ZONE` values in UTC. Every method here
/// converts to UTC first, then adds the fixed display offset, so the result is
/// identical no matter what timezone the phone is set to.
extension DateTimeExt on DateTime {
  /// Shifts this instant into the display timezone (UTC+7).
  DateTime toUtc7() => toUtc().add(AppConstants.displayTimezoneOffset);

  /// `14:30`
  String toFormattedString() => DateFormat('HH:mm').format(toUtc7());

  /// `14:30:05`
  String toTimeWithSeconds() => DateFormat('HH:mm:ss').format(toUtc7());

  /// `2024-01-15 14:30`
  String toDateTimeString() => DateFormat('yyyy-MM-dd HH:mm').format(toUtc7());

  /// `15 Jan`
  String toShortDate() => DateFormat('d MMM').format(toUtc7());

  /// `5 minutes ago`, relative to now.
  String toRelativeTime() {
    final diff = DateTime.now().toUtc().difference(toUtc());
    if (diff.isNegative) return 'just now';
    if (diff.inSeconds < 45) return 'just now';
    if (diff.inMinutes < 2) return '1 minute ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 2) return '1 hour ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 2) return 'yesterday';
    if (diff.inDays < 30) return '${diff.inDays} days ago';
    return toShortDate();
  }

  /// True when this instant falls on today's date in the display timezone.
  bool get isToday {
    final now = DateTime.now().toUtc7();
    final self = toUtc7();
    return now.year == self.year && now.month == self.month && now.day == self.day;
  }

  /// True when this instant falls on yesterday's date in the display timezone.
  bool get isYesterday {
    final ref = DateTime.now().toUtc7().subtract(const Duration(days: 1));
    final self = toUtc7();
    return ref.year == self.year && ref.month == self.month && ref.day == self.day;
  }

  /// PostgREST-compatible UTC literal, e.g. `2024-01-15T00:00:00.000Z`.
  String toApiString() => toUtc().toIso8601String();

  /// Age of this reading, used to decide whether a station counts as online.
  Duration get age => DateTime.now().toUtc().difference(toUtc());
}

/// Same helpers for values that may be absent.
extension NullableDateTimeExt on DateTime? {
  String toFormattedStringOr(String fallback) =>
      this == null ? fallback : this!.toFormattedString();

  String toRelativeTimeOr(String fallback) =>
      this == null ? fallback : this!.toRelativeTime();
}
