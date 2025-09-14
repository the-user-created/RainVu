import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/common/domain/coming_soon_args.dart";
import "package:rain_wise/common/presentation/screens/coming_soon_screen.dart";
import "package:rain_wise/core/ui/scaffold_with_nav_bar.dart";
import "package:rain_wise/features/anomaly_exploration/presentation/screens/anomaly_exploration_screen.dart";
import "package:rain_wise/features/comparative_analysis/presentation/screens/comparative_analysis_screen.dart";
import "package:rain_wise/features/data_tools/presentation/screens/data_tools_screen.dart";
import "package:rain_wise/features/home/presentation/screens/home_screen.dart";
import "package:rain_wise/features/insights_dashboard/presentation/screens/insights_screen.dart";
import "package:rain_wise/features/manage_gauges/presentation/screens/manage_gauges_screen.dart";
import "package:rain_wise/features/map/presentation/screens/map_screen.dart";
import "package:rain_wise/features/monthly_breakdown/presentation/screens/monthly_breakdown_screen.dart";
import "package:rain_wise/features/rainfall_entry/presentation/screens/rainfall_entries_screen.dart";
import "package:rain_wise/features/seasonal_patterns/presentation/screens/seasonal_patterns_screen.dart";
import "package:rain_wise/features/settings/presentation/screens/help_screen.dart";
import "package:rain_wise/features/settings/presentation/screens/notifications_screen.dart";
import "package:rain_wise/features/settings/presentation/screens/settings_screen.dart";
import "package:rain_wise/l10n/app_localizations.dart";

part "app_router.g.dart";

// 1. Define Navigator Keys
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "root");
final GlobalKey<NavigatorState> _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "home");
final GlobalKey<NavigatorState> _insightsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "insights");
final GlobalKey<NavigatorState> _mapNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "map");
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).pageNotFound),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)
              .pageNotFoundMessage(state.error?.toString() ?? "Unknown error"),
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
            TypedGoRoute<RainfallEntriesRoute>(
              path: "rainfall-entries/:month",
            ),
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
            TypedGoRoute<MonthlyBreakdownRoute>(path: "monthly-breakdown"),
            TypedGoRoute<SeasonalPatternsRoute>(path: "season-patterns"),
            TypedGoRoute<AnomalyExplorationRoute>(path: "anomaly-explore"),
            TypedGoRoute<ComparativeAnalysisRoute>(
              path: "comparative-analysis",
            ),
          ],
        ),
      ],
    ),
    // Branch 3: Map
    TypedStatefulShellBranch<MapBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<MapRoute>(path: "/map"),
      ],
    ),
    // Branch 4: Settings
    TypedStatefulShellBranch<SettingsBranch>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<SettingsRoute>(
          path: "/settings",
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<ManageGaugesRoute>(path: "manage-gauges"),
            TypedGoRoute<NotificationsRoute>(path: "notifications"),
            TypedGoRoute<HelpRoute>(path: "help"),
            TypedGoRoute<DataToolsRoute>(path: "data-tools"),
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
  ) =>
      ScaffoldWithNavBar(navigationShell: navigationShell);
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
class MapBranch extends StatefulShellBranchData {
  const MapBranch();

  static final GlobalKey<NavigatorState> $navigatorKey = _mapNavigatorKey;
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

class MapRoute extends GoRouteData with $MapRoute {
  const MapRoute();

  @override
  Page<void> buildPage(final BuildContext context, final GoRouterState state) =>
      const NoTransitionPage(child: MapScreen());
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
  const RainfallEntriesRoute({required this.month});

  final String month;
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      RainfallEntriesScreen(month: month);
}

// Insights Sub-Routes
class MonthlyBreakdownRoute extends GoRouteData with $MonthlyBreakdownRoute {
  const MonthlyBreakdownRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const MonthlyBreakdownScreen();
}

class SeasonalPatternsRoute extends GoRouteData with $SeasonalPatternsRoute {
  const SeasonalPatternsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const SeasonalPatternsScreen();
}

class AnomalyExplorationRoute extends GoRouteData
    with $AnomalyExplorationRoute {
  const AnomalyExplorationRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const AnomalyExplorationScreen();
}

class ComparativeAnalysisRoute extends GoRouteData
    with $ComparativeAnalysisRoute {
  const ComparativeAnalysisRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const ComparativeAnalysisScreen();
}

// Settings Sub-Routes
class ManageGaugesRoute extends GoRouteData with $ManageGaugesRoute {
  const ManageGaugesRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const ManageGaugesScreen();
}

class NotificationsRoute extends GoRouteData with $NotificationsRoute {
  const NotificationsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(final BuildContext context, final GoRouterState state) =>
      const NotificationsScreen();
}

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
