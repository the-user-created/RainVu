import "package:rain_wise/core/data/repositories/preferences_repository.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "preferences_provider.g.dart";

@riverpod
class UserPreferencesNotifier extends _$UserPreferencesNotifier {
  late PreferencesRepository _repository;

  @override
  Future<UserPreferences> build() async {
    _repository = await ref.watch(preferencesRepositoryProvider.future);
    return _repository.getUserPreferences();
  }

  Future<void> _updatePreferences(final UserPreferences newPreferences) async {
    // By not setting the state to loading, the UI will preserve the old state
    // until the future completes, preventing a loading indicator flicker.
    state = await AsyncValue.guard(() async {
      await _repository.saveUserPreferences(newPreferences);
      return newPreferences;
    });
  }

  Future<void> setMeasurementUnit(final MeasurementUnit unit) async {
    final UserPreferences currentState = await future;
    await _updatePreferences(currentState.copyWith(measurementUnit: unit));
  }

  Future<void> setThemeMode(final AppThemeMode mode) async {
    final UserPreferences currentState = await future;
    await _updatePreferences(currentState.copyWith(themeMode: mode));
  }

  Future<void> setFavoriteGauge(final String? gaugeId) async {
    final UserPreferences currentState = await future;
    await _updatePreferences(currentState.copyWith(favoriteGaugeId: gaugeId));
  }
}
