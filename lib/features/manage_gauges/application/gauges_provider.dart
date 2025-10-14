import "dart:async";

import "package:rainly/core/firebase/analytics_service.dart";
import "package:rainly/core/application/preferences_provider.dart";
import "package:rainly/core/data/repositories/rain_gauge_repository.dart";
import "package:rainly/shared/domain/rain_gauge.dart";
import "package:rainly/shared/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "gauges_provider.g.dart";

enum DeleteGaugeAction { reassign, deleteEntries }

@riverpod
class Gauges extends _$Gauges {
  @override
  Stream<List<RainGauge>> build() =>
      ref.watch(rainGaugeRepositoryProvider).watchGauges();

  Future<RainGauge> addGauge({required final String name}) async {
    final RainGauge newGauge = await ref
        .read(rainGaugeRepositoryProvider)
        .addGauge(name: name);
    await ref.read(analyticsServiceProvider).createGauge();
    return newGauge;
  }

  Future<void> updateGauge(final RainGauge updatedGauge) async {
    await ref.read(rainGaugeRepositoryProvider).updateGauge(updatedGauge);
    await ref.read(analyticsServiceProvider).editGauge();
  }

  Future<void> deleteGauge(
    final String gaugeId, {
    final DeleteGaugeAction? action,
  }) async {
    final UserPreferencesNotifier prefsNotifier = ref.read(
      userPreferencesProvider.notifier,
    );
    final UserPreferences currentPrefs = await ref.read(
      userPreferencesProvider.future,
    );
    if (currentPrefs.favoriteGaugeId == gaugeId) {
      await prefsNotifier.setFavoriteGauge(null);
    }

    if (action == DeleteGaugeAction.deleteEntries) {
      await ref
          .read(rainGaugeRepositoryProvider)
          .deleteGaugeAndEntries(gaugeId);
      await ref
          .read(analyticsServiceProvider)
          .deleteGauge(deletionType: "delete_entries");
    } else {
      await ref.read(rainGaugeRepositoryProvider).deleteGauge(gaugeId);
      await ref
          .read(analyticsServiceProvider)
          .deleteGauge(deletionType: "reassign");
    }
  }
}
