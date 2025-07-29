import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "notification_settings.freezed.dart";

@freezed
abstract class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    required final bool dailyReminder,
    required final TimeOfDay reminderTime,
    required final bool weeklySummary,
    required final bool weatherAlerts,
    required final bool appUpdates,
  }) = _NotificationSettings;
}
