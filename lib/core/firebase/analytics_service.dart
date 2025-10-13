import "package:firebase_analytics/firebase_analytics.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "analytics_service.g.dart";

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(final Ref ref) =>
    AnalyticsService(FirebaseAnalytics.instance);

/// A centralized wrapper for logging analytics events.
class AnalyticsService {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  // --- Screen View Event ---

  /// Logs a screen view event.
  /// Firebase automatically tracks screen views on native platforms, but this
  /// method is used with our custom GoRouter observer for more control.
  Future<void> logScreenView({required final String screenName}) async {
    // Sanitize the screen name for Firebase Analytics requirements.
    // (e.g., '/home/rainfall-entries/:month' -> 'home_rainfall_entries_month')
    String sanitizedName = screenName
        .replaceAll("/", "_")
        .replaceAll("-", "_")
        .replaceAll(":", "");

    // Remove leading underscores that result from root paths like '/'
    if (sanitizedName.startsWith("_")) {
      sanitizedName = sanitizedName.substring(1);
    }
    if (sanitizedName.isEmpty) {
      return; // Don't log empty names
    }
    if (sanitizedName.length > 100) {
      sanitizedName = sanitizedName.substring(0, 100);
    }

    await _analytics.logScreenView(
      screenName: sanitizedName,
      screenClass: "Flutter", // Best practice for Flutter apps
    );
  }

  // --- Rain Entry Events ---

  /// Logs when a user successfully saves a new rain entry.
  /// [unit] specifies the measurement unit the user selected in the UI.
  Future<void> logRainEntry({required final String unit}) async {
    await _analytics.logEvent(
      name: "log_rain_entry",
      parameters: {"unit": unit},
    );
  }

  /// Logs when a user successfully edits an existing rain entry.
  Future<void> editRainEntry() async {
    await _analytics.logEvent(name: "edit_rain_entry");
  }

  /// Logs when a user successfully deletes a rain entry.
  Future<void> deleteRainEntry() async {
    await _analytics.logEvent(name: "delete_rain_entry");
  }

  // --- Gauge Events ---

  /// Logs when a user successfully creates a new gauge.
  Future<void> createGauge() async {
    await _analytics.logEvent(name: "create_gauge");
  }

  /// Logs when a user successfully edits an existing gauge.
  Future<void> editGauge() async {
    await _analytics.logEvent(name: "edit_gauge");
  }

  /// Logs when a user successfully deletes a gauge.
  /// [deletionType] specifies whether entries were reassigned or deleted.
  Future<void> deleteGauge({required final String deletionType}) async {
    await _analytics.logEvent(
      name: "delete_gauge",
      parameters: {
        "type": deletionType,
      }, // i.e., 'reassign' or 'delete_entries'
    );
  }

  // --- Settings & Preferences Events ---

  /// Logs when a user changes their preferred measurement unit.
  Future<void> changeMeasurementUnit({required final String unit}) async {
    await _analytics.logEvent(
      name: "change_setting",
      parameters: {"setting": "measurement_unit", "value": unit},
    );
  }

  /// Logs when a user changes their hemisphere preference.
  Future<void> changeHemisphere({required final String hemisphere}) async {
    await _analytics.logEvent(
      name: "change_setting",
      parameters: {"setting": "hemisphere", "value": hemisphere},
    );
  }

  /// Logs when a user changes the anomaly detection threshold.
  Future<void> changeAnomalyThreshold({required final double threshold}) async {
    await _analytics.logEvent(
      name: "change_setting",
      parameters: {"setting": "anomaly_threshold", "value": threshold.round()},
    );
  }

  /// Logs when a user changes the app theme.
  Future<void> changeTheme({required final String theme}) async {
    await _analytics.logEvent(
      name: "change_setting",
      parameters: {"setting": "theme", "value": theme},
    );
  }

  /// Logs when a user sets or clears their favorite gauge.
  Future<void> setFavoriteGauge({required final String status}) async {
    await _analytics.logEvent(
      name: "change_setting",
      parameters: {"setting": "favorite_gauge", "value": status},
    );
  }

  // --- Data Tools Events ---

  /// Logs when a user successfully exports their data.
  Future<void> exportData({
    required final String format,
    required final String range,
  }) async {
    await _analytics.logEvent(
      name: "export_data",
      parameters: {"format": format, "range": range},
    );
  }

  /// Logs when a user successfully imports data.
  Future<void> importData({
    required final String format,
    required final int newEntries,
    required final int updatedEntries,
    required final int newGauges,
  }) async {
    await _analytics.logEvent(
      name: "import_data",
      parameters: {
        "format": format,
        "new_entries": newEntries,
        "updated_entries": updatedEntries,
        "new_gauges": newGauges,
      },
    );
  }

  /// Logs when a user resets all app data.
  Future<void> resetAppData() async {
    await _analytics.logEvent(name: "reset_app_data");
  }
}
