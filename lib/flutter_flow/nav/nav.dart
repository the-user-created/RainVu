import "dart:async";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/index.dart";
import "package:rain_wise/nav_bar.dart";

export "package:go_router/go_router.dart";

const kTransitionInfoKey = "__transition_info__";

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;

  // ignore: prefer_constructors_over_static_methods
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  String getRedirectLocation() => _redirectLocation!;

  bool hasRedirect() => _redirectLocation != null;

  void setRedirectLocationIfUnset(final String loc) =>
      _redirectLocation ??= loc;

  void clearRedirectLocation() => _redirectLocation = null;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(final AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: "/",
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (final context, final state) => const NavBarPage(), // TODO: Handle errors properly.
      routes: [
        FFRoute(
          name: "_initialize",
          path: "/",
          builder: (final context, final _) => const NavBarPage(),
        ),
        FFRoute(
          name: SettingsWidget.routeName,
          path: SettingsWidget.routePath,
          builder: (final context, final params) => params.isEmpty
              ? const NavBarPage(initialPage: "settings")
              : const NavBarPage(
                  initialPage: "settings",
                  page: SettingsWidget(),
                ),
        ),
        FFRoute(
          name: InsightsWidget.routeName,
          path: InsightsWidget.routePath,
          builder: (final context, final params) => params.isEmpty
              ? const NavBarPage(initialPage: "insights")
              : const NavBarPage(
                  initialPage: "insights",
                  page: InsightsWidget(),
                ),
        ),
        FFRoute(
          name: ManageGuagesWidget.routeName,
          path: ManageGuagesWidget.routePath,
          builder: (final context, final params) => const ManageGuagesWidget(),
        ),
        FFRoute(
          name: NotificationsWidget.routeName,
          path: NotificationsWidget.routePath,
          builder: (final context, final params) => const NotificationsWidget(),
        ),
        FFRoute(
          name: HelpWidget.routeName,
          path: HelpWidget.routePath,
          builder: (final context, final params) => const HelpWidget(),
        ),
        FFRoute(
          name: MySubscriptionWidget.routeName,
          path: MySubscriptionWidget.routePath,
          builder: (final context, final params) =>
              const MySubscriptionWidget(),
        ),
        FFRoute(
          name: DataExImportWidget.routeName,
          path: DataExImportWidget.routePath,
          builder: (final context, final params) => const DataExImportWidget(),
        ),
        FFRoute(
          name: ComingSoonWidget.routeName,
          path: ComingSoonWidget.routePath,
          builder: (final context, final params) => const ComingSoonWidget(),
        ),
        FFRoute(
          name: HomeWidget.routeName,
          path: HomeWidget.routePath,
          builder: (final context, final params) => params.isEmpty
              ? const NavBarPage(initialPage: "home")
              : const NavBarPage(
                  initialPage: "home",
                  page: HomeWidget(),
                ),
        ),
        FFRoute(
          name: MapWidget.routeName,
          path: MapWidget.routePath,
          builder: (final context, final params) => params.isEmpty
              ? const NavBarPage(initialPage: "map")
              : const NavBarPage(
                  initialPage: "map",
                  page: MapWidget(),
                ),
        ),
        FFRoute(
          name: MonthlyBreakdownWidget.routeName,
          path: MonthlyBreakdownWidget.routePath,
          builder: (final context, final params) =>
              const MonthlyBreakdownWidget(),
        ),
        FFRoute(
          name: SeasonPatternsWidget.routeName,
          path: SeasonPatternsWidget.routePath,
          builder: (final context, final params) =>
              const SeasonPatternsWidget(),
        ),
        FFRoute(
          name: AnomalyExploreWidget.routeName,
          path: AnomalyExploreWidget.routePath,
          builder: (final context, final params) =>
              const AnomalyExploreWidget(),
        ),
        FFRoute(
          name: ComparativeAnalysisWidget.routeName,
          path: ComparativeAnalysisWidget.routePath,
          builder: (final context, final params) =>
              const ComparativeAnalysisWidget(),
        ),
        FFRoute(
          name: RainfallEntriesWidget.routeName,
          path: RainfallEntriesWidget.routePath,
          builder: (final context, final params) =>
              const RainfallEntriesWidget(),
        ),
      ].map((final r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((final e) => e.value != null)
            .map((final e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    final String name, {
    final bool mounted = true,
    final Map<String, String> pathParameters = const <String, String>{},
    final Map<String, String> queryParameters = const <String, String>{},
    final Object? extra,
    final bool ignoreRedirect = false,
  }) =>
      !mounted ||
              GoRouter.of(this).shouldRedirect(ignoreRedirect: ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  Future<void> pushNamedAuth(
    final String name, {
    final bool mounted = true,
    final Map<String, String> pathParameters = const <String, String>{},
    final Map<String, String> queryParameters = const <String, String>{},
    final Object? extra,
    final bool ignoreRedirect = false,
  }) async =>
      !mounted ||
              GoRouter.of(this).shouldRedirect(ignoreRedirect: ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go("/");
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;

  void prepareAuthEvent({final bool ignoreRedirect = false}) {
    if (!(appState.hasRedirect() && !ignoreRedirect)) {
      appState.notifyOnAuthChange = false;
    }
  }

  bool shouldRedirect({final bool ignoreRedirect = false}) =>
      !ignoreRedirect && appState.hasRedirect();

  void clearRedirectLocation() => appState.clearRedirectLocation();

  void setRedirectLocationIfUnset(final String location) {
    appState.notifyOnAuthChange = false;
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra! as Map<String, dynamic> : {};

  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);

  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));

  bool isAsyncParam(final MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;

  bool get hasFutures => state.allParams.entries.any(isAsyncParam);

  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (final param) async {
            final dynamic doc = await asyncParams[param.key]!(param.value)
                .onError((final _, final __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      )
          .onError((final _, final __) => [false])
          .then((final v) => v.every((final e) => e));
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(final AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (final context, final state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final Widget page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (final context, final _) =>
                      builder(context, ffParams),
                )
              : builder(context, ffParams);
          final Widget child = page;

          final TransitionInfo transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: (final context, final animation,
                          final secondaryAnimation, final child) =>
                      PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  factory TransitionInfo.appDefault() =>
      const TransitionInfo(hasTransition: false);

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;
}

class RootPageContext {
  const RootPageContext({required this.isRootPage, this.errorRoute});

  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(final BuildContext context) {
    final RootPageContext? rootPageContext = context.read<RootPageContext?>();
    final bool isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != "/" &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(final Widget child, {final String? errorRoute}) =>
      Provider.value(
        value: RootPageContext(isRootPage: true, errorRoute: errorRoute),
        child: child,
      );
}
