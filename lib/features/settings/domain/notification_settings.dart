import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "notification_settings.freezed.dart";

part "notification_settings.g.dart";

/// Custom converter for TimeOfDay to allow JSON serialization.
class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(final String json) {
    final List<String> parts = json.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  String toJson(final TimeOfDay timeOfDay) =>
      "${timeOfDay.hour}:${timeOfDay.minute}";
}

@freezed
abstract class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    required final bool dailyReminder,
    @TimeOfDayConverter() required final TimeOfDay reminderTime,
    required final bool weeklySummary,
    required final bool weatherAlerts,
    required final bool appUpdates,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(final Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}
