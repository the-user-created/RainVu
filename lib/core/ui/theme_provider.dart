import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "theme_provider.g.dart";

const _themeModeKey = "theme_mode";

/// Provider for the SharedPreferences instance.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(final Ref ref) =>
    SharedPreferences.getInstance();

/// Notifier for managing and persisting the app's theme mode.
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  late SharedPreferences _prefs;

  @override
  ThemeMode build() => ref.watch(sharedPreferencesProvider).when(
        data: (final prefs) {
          _prefs = prefs;
          final String? themeModeString = _prefs.getString(_themeModeKey);
          return ThemeMode.values.firstWhere(
            (final e) => e.toString() == themeModeString,
            orElse: () => ThemeMode.system,
          );
        },
        loading: () => ThemeMode.system,
        error: (final error, final stack) {
          debugPrint("Error loading theme mode: $error");
          return ThemeMode.system;
        },
      );

  /// Sets the theme mode and persists it to SharedPreferences.
  Future<void> setThemeMode(final ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.toString());
    state = mode;
  }
}
