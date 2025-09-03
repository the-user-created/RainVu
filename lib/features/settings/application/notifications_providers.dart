import "dart:async";

import "package:flutter/material.dart";
import "package:rain_wise/features/settings/data/settings_repository.dart";
import "package:rain_wise/features/settings/domain/notification_settings.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "notifications_providers.g.dart";

@riverpod
class NotificationSettingsNotifier extends _$NotificationSettingsNotifier {
  late SettingsRepository _repository;

  @override
  Future<NotificationSettings> build() async {
    _repository = await ref.watch(settingsRepositoryProvider.future);
    return _repository.getNotificationSettings();
  }

  Future<void> _updateSettings(final NotificationSettings newSettings) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveNotificationSettings(newSettings);
      return newSettings;
    });
  }

  Future<void> setDailyReminder(final bool enabled) async {
    final NotificationSettings currentState = await future;
    await _updateSettings(currentState.copyWith(dailyReminder: enabled));
  }

  Future<void> setReminderTime(final TimeOfDay time) async {
    final NotificationSettings currentState = await future;
    await _updateSettings(currentState.copyWith(reminderTime: time));
  }

  Future<void> setWeeklySummary(final bool enabled) async {
    final NotificationSettings currentState = await future;
    await _updateSettings(currentState.copyWith(weeklySummary: enabled));
  }

  Future<void> setWeatherAlerts(final bool enabled) async {
    final NotificationSettings currentState = await future;
    await _updateSettings(currentState.copyWith(weatherAlerts: enabled));
  }

  Future<void> setAppUpdates(final bool enabled) async {
    final NotificationSettings currentState = await future;
    await _updateSettings(currentState.copyWith(appUpdates: enabled));
  }
}
