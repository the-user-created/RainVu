import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/common/domain/coming_soon_args.dart";
import "package:rain_wise/common/presentation/screens/coming_soon_screen.dart";
import "package:rain_wise/core/ui/scaffold_with_nav_bar.dart";
import "package:rain_wise/features/changelog/presentation/screens/changelog_screen.dart";
import "package:rain_wise/features/daily_breakdown/presentation/screens/daily_breakdown_screen.dart";
import "package:rain_wise/features/data_tools/presentation/screens/data_tools_screen.dart";
import "package:rain_wise/features/home/presentation/screens/home_screen.dart";
import "package:rain_wise/features/insights_dashboard/presentation/screens/insights_screen.dart";
import "package:rain_wise/features/insights_dashboard/presentation/screens/monthly_averages_screen.dart";
import "package:rain_wise/features/manage_gauges/presentation/screens/manage_gauges_screen.dart";
import "package:rain_wise/features/oss_licenses/presentation/screens/license_detail_screen.dart";
import "package:rain_wise/features/oss_licenses/presentation/screens/oss_licenses_screen.dart";
import "package:rain_wise/features/rainfall_entry/presentation/screens/rainfall_entries_screen.dart";
import "package:rain_wise/features/seasonal_trends/presentation/screens/seasonal_trends_screen.dart";
import "package:rain_wise/features/settings/presentation/screens/help_screen.dart";
import "package:rain_wise/features/settings/presentation/screens/settings_screen.dart";
import "package:rain_wise/features/unusual_patterns/presentation/screens/unusual_patterns_screen.dart";
import "package:rain_wise/features/yearly_comparison/presentation/screens/yearly_comparison_screen.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/oss_licenses.dart" as oss;

part "app_router.g.dart";

// 1. Define Navigator Keys
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: "root",
);
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: "home",
);
final GlobalKey<NavigatorState> _insightsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "insights");
final GlobalKey<NavigatorState> _gaugesNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: "gauges",
);
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "settings");

// 2. Define the GoRouter provider
final goRouterProvider = Provider<GoRouter>(
  (final ref) => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: "/home",
    debugLogDiagnostics: true,
    routes: $appRoutes,
    errorBuilder: (final context, final state) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).pageNotFound)),
      body: Center(
        child: Text(
          AppLocalizations.of(
            context,
          ).pageNotFoundMessage(state.error?.toString() ?? "Unknown error"),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
);

// --- Root and Non-Shell Routes ---
@TypedGoRoute<InitialRoute>(path: "/")
class InitialRoute extends GoRouteData with $InitialRoute {
  const InitialRoute();

  @override
  String? redirect(final BuildContext context, final GoRouterState state) =>
      const HomeRoute().location;
}

@TypedGoRoute<ComingSoonRoute>(path: "/coming-soon")
class ComingSoonRoute extends GoRouteData with $ComingSoonRoute {
  const ComingSoonRoute({this.$extra});

  final ComingSoonScreenArgs? $extra;

  @override
  Widget build(final BuildContext context, final GoRouterState state) {
    final ComingSoonScreenArgs args = $extra ?? const ComingSoonScreenArgs();
    return ComingSoonScreen(
      pageTitle: args.pageTitle,
      headline: args.headline,
      message: args.message,
    );
  }
}

// --- Stateful Shell Route Definition ---
@TypedStatefulShellRoute<AppShellRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    // Branch 1: Home
    TypedStatefulShellBranch<HomeBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<HomeRoute>(
          path: "/home",
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<RainfallEntriesRoute>(path: "rainfall-entries/:month"),
          ],
        ),
      ],
    ),
    // Branch 2: Insights
    TypedStatefulShellBranch<InsightsBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<InsightsRoute>(
          path: "/insights",
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<MonthlyComparisonRoute>(path: "monthly-comparison"),
            TypedGoRoute<DailyBreakdownRoute>(path: "monthly-breakdown"),
            TypedGoRoute<SeasonalTrendsRoute>(path: "season-patterns"),
            TypedGoRoute<UnusualPatternsRoute>(path: "anomaly-explore"),
            TypedGoRoute<YearlyComparisonRoute>(path: "comparative-analysis"),
          ],
        ),
      ],
    ),
    // Branch 3: Gauges
    TypedStatefulShellBranch<GaugesBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<GaugesRoute>(path: "/gauges"),
      ],
    ),
    // Branch 4: Settings
    TypedStatefulShellBranch<SettingsBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<SettingsRoute>(
          path: "/settings",
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<HelpRoute>(path: "help"),
            TypedGoRoute<DataToolsRoute>(path: "data-tools"),
            TypedGoRoute<OssLicensesRoute>(
              path: "oss-licenses",
              routes: <TypedGoRoute<GoRouteData>>[
                TypedGoRoute<LicenseDetailRoute>(path: "details/:packageName"),
              ],
            ),
            TypedGoRoute<ChangelogRoute>(path: "changelog"),
          ],
        ),
      ],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(
    final BuildContext context,
    final GoRouterState state,
    final StatefulNavigationShell navigationShell,
  ) => ScaffoldWithNavBar(navigationShell: navigationShell);
}

// --- Shell Branches ---
// ignore: avoid_classes_with_only_static_members
class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();

  static final GlobalKey<NavigatorState> $navigatorKey = _homeNavigatorKey;
}

// ignore: avoid_classes_with_only_static_members
class InsightsBranch extends StatefulShellBranchData {
  const InsightsBranch();

  static final GlobalKey<NavigatorState> $navigatorKey = _insightsNavigatorKey;
}

// ignore: avoid_classes_with_only_static_members
class GaugesBranch extends StatefulShellBranchData {
  const GaugesBranch();

  static final GlobalKey<NavigatorState> $navigatorKey = _gaugesNavigatorKey;
}

// ignore: avoid_classes_with_only_static_members
class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();

  static final GlobalKey<NavigatorState> $navigatorKey = _settingsNavigatorKey;
}

// --- Base Shell Routes ---
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Page<void> buildPage(final BuildContext context, final GoRouterState state) =>
      const NoTransitionPage(child: HomeScreen());
}

class InsightsRoute extends GoRouteData with $InsightsRoute {
  const InsightsRoute();

  @override
  Page<void> buildPage(final BuildContext context, final GoRouterState state) =>
      const NoTransitionPage(child: InsightsScreen());
}

class GaugesRoute extends GoRouteData with $GaugesRoute {
  const GaugesRoute();

  @override
  Page<void> buildPage(final BuildContext context, final GoRouterState state) =>
      const NoTransitionPage(child: ManageGaugesScreen());
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Page<void> buildPage(final BuildContext context, final GoRouterState state) =>
      const NoTransitionPage(child: SettingsScreen());
}

// --- Sub-Routes (Pushed on Root Navigator) ---

// Home Sub-Route
class RainfallEntriesRoute extends GoRouteData with $RainfallEntriesRoute {
  const RainfallEntriesRoute({required this.month, this.gaugeId});

  final String month;
  final String? gaugeId;
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      RainfallEntriesScreen(month: month, gaugeId: gaugeId);
}

// Insights Sub-Routes
class MonthlyComparisonRoute extends GoRouteData with $MonthlyComparisonRoute {
  const MonthlyComparisonRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const MonthlyAveragesScreen();
}

class DailyBreakdownRoute extends GoRouteData with $DailyBreakdownRoute {
  const DailyBreakdownRoute({this.month});

  /// An optional initial month to display, in 'YYYY-MM' format via query param.
  final String? month;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      DailyBreakdownScreen(initialMonth: month);
}

class SeasonalTrendsRoute extends GoRouteData with $SeasonalTrendsRoute {
  const SeasonalTrendsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const SeasonalTrendsScreen();
}

class UnusualPatternsRoute extends GoRouteData with $UnusualPatternsRoute {
  const UnusualPatternsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const UnusualPatternsScreen();
}

class YearlyComparisonRoute extends GoRouteData with $YearlyComparisonRoute {
  const YearlyComparisonRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const YearlyComparisonScreen();
}

// Settings Sub-Routes
class HelpRoute extends GoRouteData with $HelpRoute {
  const HelpRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const HelpScreen();
}

class DataToolsRoute extends GoRouteData with $DataToolsRoute {
  const DataToolsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const DataToolsScreen();
}

class OssLicensesRoute extends GoRouteData with $OssLicensesRoute {
  const OssLicensesRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const OssLicensesScreen();
}

class ChangelogRoute extends GoRouteData with $ChangelogRoute {
  const ChangelogRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const ChangelogScreen();
}

class LicenseDetailRoute extends GoRouteData with $LicenseDetailRoute {
  const LicenseDetailRoute({required this.packageName});

  final String packageName;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) {
    final oss.Package package = oss.allDependencies.firstWhere(
      (final p) => p.name == packageName,
      orElse: () => const oss.Package(
        name: "Not Found",
        description: "",
        authors: [],
        isMarkdown: false,
        isSdk: false,
        dependencies: [],
        devDependencies: [],
      ),
    );
    return LicenseDetailScreen(package: package);
  }
}
