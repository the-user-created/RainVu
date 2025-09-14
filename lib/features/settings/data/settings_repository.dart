import "dart:convert";

import "package:flutter/material.dart";
import "package:rain_wise/core/data/local/shared_prefs.dart";
import "package:rain_wise/features/settings/domain/notification_settings.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "settings_repository.g.dart";

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _notificationSettingsKey = "notification_settings";
  static const _userPreferencesKey = "user_preferences";

  /// Retrieves [NotificationSettings] from local storage.
  /// If no settings are found, it returns a default configuration.
  NotificationSettings getNotificationSettings() {
    final String? jsonString = _prefs.getString(_notificationSettingsKey);
    if (jsonString != null) {
      return NotificationSettings.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    }
    // Return default settings if nothing is stored yet.
    return const NotificationSettings(
      dailyReminder: true,
      reminderTime: TimeOfDay(hour: 8, minute: 0),
      weeklySummary: true,
      weatherAlerts: true,
      appUpdates: true,
    );
  }

  /// Saves the provided [NotificationSettings] to local storage.
  Future<void> saveNotificationSettings(
    final NotificationSettings settings,
  ) async {
    final String jsonString = jsonEncode(settings.toJson());
    await _prefs.setString(_notificationSettingsKey, jsonString);
  }

  /// Retrieves [UserPreferences] from local storage.
  /// If no preferences are found, it returns a default configuration.
  UserPreferences getUserPreferences() {
    final String? jsonString = _prefs.getString(_userPreferencesKey);
    if (jsonString != null) {
      return UserPreferences.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    }
    // Return default preferences if nothing is stored yet.
    return const UserPreferences();
  }

  /// Saves the provided [UserPreferences] to local storage.
  Future<void> saveUserPreferences(
    final UserPreferences preferences,
  ) async {
    final String jsonString = jsonEncode(preferences.toJson());
    await _prefs.setString(_userPreferencesKey, jsonString);
  }
}

@riverpod
Future<SettingsRepository> settingsRepository(
  final Ref ref,
) async {
  final SharedPreferences prefs =
      await ref.watch(sharedPreferencesProvider.future);
  return SettingsRepository(prefs);
}
