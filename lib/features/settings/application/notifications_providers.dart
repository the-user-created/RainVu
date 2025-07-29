import "package:flutter/material.dart";
import "package:rain_wise/features/settings/domain/notification_settings.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "notifications_providers.g.dart";

@riverpod
class NotificationSettingsNotifier extends _$NotificationSettingsNotifier {
  // In a real app, this would be loaded from a repository
  // (e.g., SharedPreferences, Firestore)
  @override
  NotificationSettings build() => const NotificationSettings(
        dailyReminder: true,
        reminderTime: TimeOfDay(hour: 8, minute: 0),
        weeklySummary: true,
        weatherAlerts: true,
        appUpdates: true,
      );

  void setDailyReminder(final bool enabled) {
    state = state.copyWith(dailyReminder: enabled);
    // TODO: Persist change to a repository
  }

  void setReminderTime(final TimeOfDay time) {
    state = state.copyWith(reminderTime: time);
    // TODO: Persist change to a repository
  }

  void setWeeklySummary(final bool enabled) {
    state = state.copyWith(weeklySummary: enabled);
    // TODO: Persist change to a repository
  }

  void setWeatherAlerts(final bool enabled) {
    state = state.copyWith(weatherAlerts: enabled);
    // TODO: Persist change to a repository
  }

  void setAppUpdates(final bool enabled) {
    state = state.copyWith(appUpdates: enabled);
    // TODO: Persist change to a repository
  }
}
