import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:rainvu/app_constants.dart";
import "package:rainvu/core/data/local/shared_prefs.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "telemetry_manager.g.dart";

@Riverpod(keepAlive: true)
class TelemetryManager extends _$TelemetryManager {
  late SharedPreferences _prefs;

  @override
  Future<bool> build() async {
    _prefs = await ref.watch(sharedPreferencesProvider.future);
    return _prefs.getBool(AppConstants.telemetryEnabledKey) ?? false;
  }

  /// Applies the persisted telemetry setting to Firebase services.
  /// MUST be called after Firebase.initializeApp().
  Future<void> applyPersistedSetting() async {
    try {
      // Await the build method to ensure the state is loaded from prefs.
      final bool isEnabled = await future;
      await _setFirebaseCollectionStatus(isEnabled);
    } catch (e, s) {
      debugPrint("Could not apply telemetry setting on init: $e");
      // Don't crash the app if this fails, but log it if possible.
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to apply initial telemetry setting",
      );
    }
  }

  /// Enables or disables all telemetry (Analytics and Crashlytics) and persists the choice.
  Future<void> setTelemetryEnabled(final bool isEnabled) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _prefs.setBool(AppConstants.telemetryEnabledKey, isEnabled);
      await _setFirebaseCollectionStatus(isEnabled);

      if (isEnabled) {
        await FirebaseCrashlytics.instance.sendUnsentReports();
      } else {
        await FirebaseCrashlytics.instance.deleteUnsentReports();
      }

      return isEnabled;
    });
  }

  /// Centralized method to update Firebase SDKs.
  Future<void> _setFirebaseCollectionStatus(final bool isEnabled) async {
    // These calls persist the setting on the device via the Firebase SDK.
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(isEnabled);
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      isEnabled,
    );
  }
}
