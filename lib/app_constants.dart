abstract class AppConstants {
  /// The padding applied to the horizontal edges of top-level elements in
  /// widgets
  static const double horiEdgePadding = 24;

  // Default Rain Gauge
  static const String defaultGaugeId = "default_gauge_001";
  static const String defaultGaugeName = "Default Gauge";

  // Global shared prefs keys (which are kept even after app reset)
  static const String onboardingCompleteKey = "onboarding_complete";
  static const String telemetryEnabledKey = "telemetry_enabled";

  /// The Apple App Store ID for RainVu.
  static const String kAppStoreId = "6754812264";

  /// The Google Play Store URL for RainVu.
  static const String kPlayStoreUrl =
      "https://play.google.com/store/apps/details?id=com.astraen.rainvu";

  /// The Apple App Store URL for RainVu.
  static const String kAppStoreUrl =
      "https://apps.apple.com/us/app/rainvu/id6754812264";

  // Legal URLs
  static const String kPrivacyPolicyUrl =
      "https://www.astraen.dev/rainvu/privacy";
  static const String kTermsOfServiceUrl =
      "https://www.astraen.dev/rainvu/terms";
}
