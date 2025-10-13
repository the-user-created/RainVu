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
}
