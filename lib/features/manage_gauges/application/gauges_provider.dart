import "dart:async";

import "package:rain_wise/core/data/repositories/rain_gauge_repository.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "gauges_provider.g.dart";

// TODO: Allow users to set a default gauge

@riverpod
class Gauges extends _$Gauges {
  @override
  Stream<List<RainGauge>> build() =>
      ref.watch(rainGaugeRepositoryProvider).watchGauges();

  Future<void> addGauge({
    required final String name,
  }) async {
    await ref
        .read(rainGaugeRepositoryProvider)
        .addGauge(name: name);
  }

  Future<void> updateGauge(final RainGauge updatedGauge) async {
    await ref.read(rainGaugeRepositoryProvider).updateGauge(updatedGauge);
  }

  Future<void> deleteGauge(final String gaugeId) async {
    await ref.read(rainGaugeRepositoryProvider).deleteGauge(gaugeId);
  }
}
