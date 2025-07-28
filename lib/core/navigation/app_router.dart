import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_routes.dart";

/// A Riverpod provider that creates and exposes the [GoRouter] instance.
final goRouterProvider = Provider<GoRouter>(
  (final ref) => GoRouter(
    navigatorKey: AppRoutes.instance.rootNavigatorKey,
    initialLocation: "/home",
    debugLogDiagnostics: true,
    // Enable for easier debugging
    routes: AppRoutes.instance.routes,

    // A simple error page for routes that are not found.
    errorBuilder: (final context, final state) => Scaffold(
      appBar: AppBar(
        title: const Text("Page Not Found"),
      ),
      body: Center(
        child: Text(
          "The page you are looking for does not exist.\n\nError: ${state.error}",
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
);
