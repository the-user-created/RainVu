import "package:rain_wise/features/settings/data/settings_repository.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "preferences_provider.g.dart";

@riverpod
class UserPreferencesNotifier extends _$UserPreferencesNotifier {
  late SettingsRepository _repository;

  @override
  Future<UserPreferences> build() async {
    _repository = await ref.watch(settingsRepositoryProvider.future);
    return _repository.getUserPreferences();
  }

  Future<void> _updatePreferences(final UserPreferences newPreferences) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveUserPreferences(newPreferences);
      return newPreferences;
    });
  }

  Future<void> setMeasurementUnit(final MeasurementUnit unit) async {
    final UserPreferences currentState = await future;
    await _updatePreferences(currentState.copyWith(measurementUnit: unit));
  }
}
