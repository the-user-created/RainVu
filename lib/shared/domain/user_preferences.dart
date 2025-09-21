import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/app_constants.dart";

part "user_preferences.freezed.dart";

part "user_preferences.g.dart";

enum MeasurementUnit { mm, inch }

enum AppThemeMode { light, dark, system }

extension MeasurementUnitExtension on MeasurementUnit {
  String get name {
    switch (this) {
      case MeasurementUnit.mm:
        return "mm";
      case MeasurementUnit.inch:
        return "in";
    }
  }
}

@freezed
abstract class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default(MeasurementUnit.mm) final MeasurementUnit measurementUnit,
    @Default(AppThemeMode.system) final AppThemeMode themeMode,
    @Default(AppConstants.defaultGaugeId) final String? favoriteGaugeId,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(final Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
