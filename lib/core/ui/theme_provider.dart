import "package:flutter/material.dart";
import "package:rain_wise/features/settings/application/preferences_provider.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "theme_provider.g.dart";

@riverpod
ThemeMode themeMode(final Ref ref) {
  final AsyncValue<UserPreferences> userPreferences = ref.watch(
    userPreferencesProvider,
  );

  return userPreferences.when(
    data: (final prefs) {
      switch (prefs.themeMode) {
        case AppThemeMode.light:
          return ThemeMode.light;
        case AppThemeMode.dark:
          return ThemeMode.dark;
        case AppThemeMode.system:
          return ThemeMode.system;
      }
    },
    // Provide a default theme mode during loading or on error
    loading: () => ThemeMode.system,
    error: (final err, final stack) {
      debugPrint("Error loading theme preference: $err");
      return ThemeMode.system;
    },
  );
}
