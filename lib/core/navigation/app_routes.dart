import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";
import "package:rain_wise/core/ui/scaffold_with_nav_bar.dart";
import "package:rain_wise/features/data_tools/presentation/screens/data_tools_screen.dart";
import "package:rain_wise/features/home/presentation/screens/home_screen.dart";
import "package:rain_wise/features/insights/presentation/screens/insights_screen.dart";
import "package:rain_wise/features/manage_gauges/presentation/screens/manage_gauges_screen.dart";
import "package:rain_wise/features/map/presentation/screens/map_screen.dart";
import "package:rain_wise/features/settings/presentation/screens/help_screen.dart";
import "package:rain_wise/features/settings/presentation/screens/notifications_screen.dart";
import "package:rain_wise/features/settings/presentation/screens/settings_screen.dart";
import "package:rain_wise/features/subscription/presentation/screens/subscription_details_screen.dart";
import "package:rain_wise/insights/anomaly_explore/anomaly_explore_widget.dart";
import "package:rain_wise/insights/comparative_analysis/comparative_analysis_widget.dart";
import "package:rain_wise/insights/monthly_breakdown/monthly_breakdown_widget.dart";
import "package:rain_wise/insights/season_patterns/season_patterns_widget.dart";
import "package:rain_wise/misc/coming_soon/coming_soon_widget.dart";
import "package:rain_wise/misc/rainfall_entries/rainfall_entries_widget.dart";

/// Defines the route configuration for the application.
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Navigator keys as instance members of a singleton
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root");
  final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "home");
  final _insightsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "insights");
  final _mapNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "map");
  final _settingsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "settings");

  // Singleton instance
  static final AppRoutes instance = AppRoutes._();

  // Helper method to build sub-routes
  GoRoute _buildSubRoute(
    final String path,
    final String name,
    final Widget child,
  ) =>
      GoRoute(
        path: path,
        name: name,
        parentNavigatorKey: rootNavigatorKey,
        builder: (final context, final state) => child,
      );

  // Routes as instance getter
  List<RouteBase> get routes => [
        GoRoute(
          path: "/",
          redirect: (final _, final __) => AppRouteNames.homePath,
        ),
        StatefulShellRoute.indexedStack(
          builder: (final context, final state, final navigationShell) =>
              ScaffoldWithNavBar(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                  path: AppRouteNames.homePath,
                  name: AppRouteNames.homeName,
                  pageBuilder: (final context, final state) =>
                      const NoTransitionPage(child: HomeScreen()),
                  routes: [
                    _buildSubRoute(
                      AppRouteNames.rainfallEntriesPath,
                      AppRouteNames.rainfallEntriesName,
                      const RainfallEntriesWidget(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _insightsNavigatorKey,
              routes: [
                GoRoute(
                  path: AppRouteNames.insightsPath,
                  name: AppRouteNames.insightsName,
                  pageBuilder: (final context, final state) =>
                      const NoTransitionPage(child: InsightsScreen()),
                  routes: [
                    _buildSubRoute(
                      AppRouteNames.monthlyBreakdownPath,
                      AppRouteNames.monthlyBreakdownName,
                      const MonthlyBreakdownWidget(),
                    ),
                    _buildSubRoute(
                      AppRouteNames.seasonPatternsPath,
                      AppRouteNames.seasonPatternsName,
                      const SeasonPatternsWidget(),
                    ),
                    _buildSubRoute(
                      AppRouteNames.anomalyExplorePath,
                      AppRouteNames.anomalyExploreName,
                      const AnomalyExploreWidget(),
                    ),
                    _buildSubRoute(
                      AppRouteNames.comparativeAnalysisPath,
                      AppRouteNames.comparativeAnalysisName,
                      const ComparativeAnalysisWidget(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _mapNavigatorKey,
              routes: [
                GoRoute(
                  path: AppRouteNames.mapPath,
                  name: AppRouteNames.mapName,
                  pageBuilder: (final context, final state) =>
                      const NoTransitionPage(child: MapScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _settingsNavigatorKey,
              routes: [
                GoRoute(
                  path: AppRouteNames.settingsPath,
                  name: AppRouteNames.settingsName,
                  pageBuilder: (final context, final state) =>
                      const NoTransitionPage(child: SettingsScreen()),
                  routes: [
                    _buildSubRoute(
                      AppRouteNames.manageGaugesPath,
                      AppRouteNames.manageGaugesName,
                      const ManageGaugesScreen(),
                    ),
                    _buildSubRoute(
                      AppRouteNames.notificationsPath,
                      AppRouteNames.notificationsName,
                      const NotificationsScreen(),
                    ),
                    _buildSubRoute(
                      AppRouteNames.helpPath,
                      AppRouteNames.helpName,
                      const HelpScreen(),
                    ),
                    _buildSubRoute(
                      AppRouteNames.mySubscriptionPath,
                      AppRouteNames.mySubscriptionName,
                      const SubscriptionDetailsScreen(),
                    ),
                    _buildSubRoute(
                      AppRouteNames.dataToolsPath,
                      AppRouteNames.dataToolsName,
                      const DataToolsScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRouteNames.comingSoonPath,
          name: AppRouteNames.comingSoonName,
          builder: (final context, final state) => const ComingSoonWidget(),
        ),
      ];
}
