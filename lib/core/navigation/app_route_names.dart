/// A class that holds all route names and paths as static constants.
///
/// This prevents the use of "magic strings" for navigation and ensures a
/// single source of truth for all routes.
abstract class AppRouteNames {
  // --- Shell Route Names ---
  static const String homeName = "home";
  static const String insightsName = "insights";
  static const String mapName = "map";
  static const String settingsName = "settings";

  // --- Shell Route Paths ---
  static const String homePath = "/home";
  static const String insightsPath = "/insights";
  static const String mapPath = "/map";
  static const String settingsPath = "/settings";

  // --- Home Sub-routes ---
  static const String rainfallEntriesName = "rainfallEntries";
  static const String rainfallEntriesPath = "rainfall-entries";

  // --- Insights Sub-routes ---
  static const String monthlyBreakdownName = "monthlyBreakdown";
  static const String monthlyBreakdownPath = "monthly-breakdown";
  static const String seasonPatternsName = "seasonPatterns";
  static const String seasonPatternsPath = "season-patterns";
  static const String anomalyExploreName = "anomalyExplore";
  static const String anomalyExplorePath = "anomaly-explore";
  static const String comparativeAnalysisName = "comparativeAnalysis";
  static const String comparativeAnalysisPath = "comparative-analysis";

  // --- Settings Sub-routes ---
  static const String manageGaugesName = "manageGauges";
  static const String manageGaugesPath = "manage-gauges";
  static const String notificationsName = "notifications";
  static const String notificationsPath = "notifications";
  static const String helpName = "help";
  static const String helpPath = "help";
  static const String mySubscriptionName = "mySubscription";
  static const String mySubscriptionPath = "my-subscription";
  static const String dataExImportName = "dataExImport";
  static const String dataExImportPath = "data-ex-import";

  // --- Top-level Routes (No Shell) ---
  static const String comingSoonName = "comingSoon";
  static const String comingSoonPath = "/coming-soon";
}
