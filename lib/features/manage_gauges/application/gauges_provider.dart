import "dart:async";

import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/data/repositories/rain_gauge_repository.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "gauges_provider.g.dart";

@riverpod
class Gauges extends _$Gauges {
  @override
  Stream<List<RainGauge>> build() =>
      ref.watch(rainGaugeRepositoryProvider).watchGauges();

  Future<RainGauge> addGauge({required final String name}) =>
      ref.read(rainGaugeRepositoryProvider).addGauge(name: name);

  Future<void> updateGauge(final RainGauge updatedGauge) async {
    await ref.read(rainGaugeRepositoryProvider).updateGauge(updatedGauge);
  }

  Future<void> deleteGauge(final String gaugeId) async {
    final UserPreferencesNotifier prefsNotifier = ref.read(
      userPreferencesProvider.notifier,
    );
    final UserPreferences currentPrefs = await ref.read(
      userPreferencesProvider.future,
    );
    if (currentPrefs.favoriteGaugeId == gaugeId) {
      await prefsNotifier.setFavoriteGauge(null);
    }
    await ref.read(rainGaugeRepositoryProvider).deleteGauge(gaugeId);
  }
}
