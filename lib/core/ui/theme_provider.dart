import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "theme_provider.g.dart";

const _themeModeKey = "theme_mode";

/// Provider for the SharedPreferences instance.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(final SharedPreferencesRef ref) =>
    SharedPreferences.getInstance();

/// Notifier for managing and persisting the app's theme mode.
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  late SharedPreferences _prefs;

  @override
  ThemeMode build() {
    // We expect the SharedPreferences provider to be initialized
    // before this notifier is used.
    final AsyncValue<SharedPreferences> prefsAsyncValue =
        ref.watch(sharedPreferencesProvider);
    // TODO: Brittle Provider Initialization: ThemeModeNotifier uses a force unwrap (.value!) which relies on pre-loading in main.dart, making it fragile.
    _prefs = prefsAsyncValue.value!;

    final String? themeModeString = _prefs.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (final e) => e.toString() == themeModeString,
      orElse: () => ThemeMode.system, // Default to system theme
    );
  }

  /// Sets the theme mode and persists it to SharedPreferences.
  Future<void> setThemeMode(final ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.toString());
    state = mode;
  }
}
