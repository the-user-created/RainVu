import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_routes.dart";
import "package:rain_wise/l10n/app_localizations.dart";

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
        title: Text(AppLocalizations.of(context).pageNotFound),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context).pageNotFoundMessage(state.error ?? "Unknown error"),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
);
