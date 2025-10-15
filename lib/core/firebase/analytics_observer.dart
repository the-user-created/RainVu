import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/firebase/analytics_service.dart";

class AnalyticsObserver extends NavigatorObserver {
  AnalyticsObserver({required this.ref});

  final Ref ref;

  @override
  void didPush(
    final Route<dynamic> route,
    final Route<dynamic>? previousRoute,
  ) {
    super.didPush(route, previousRoute);
    _logScreenView(route);
  }

  @override
  void didReplace({
    final Route<dynamic>? newRoute,
    final Route<dynamic>? oldRoute,
  }) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logScreenView(newRoute);
    }
  }

  @override
  void didPop(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // When a route is popped, the previous route becomes the current screen.
    if (previousRoute != null) {
      _logScreenView(previousRoute);
    }
  }

  void _logScreenView(final Route<dynamic> route) {
    // GoRouter sets the route name to its path pattern (e.g., '/home', '/settings/data-tools')
    final String? screenName = route.settings.name;

    if (screenName != null && screenName.isNotEmpty) {
      ref.read(analyticsServiceProvider).logScreenView(screenName: screenName);
    }
  }
}
