import "dart:async";

import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/manage_gauges/data/gauges_repository.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "gauges_provider.g.dart";

@riverpod
class Gauges extends _$Gauges {
  @override
  Stream<List<RainGauge>> build() =>
      ref.watch(gaugesRepositoryProvider).watchGauges();

  Future<void> addGauge({
    required final String name,
    final double? lat,
    final double? lng,
  }) async {
    await ref
        .read(gaugesRepositoryProvider)
        .addGauge(name: name, lat: lat, lng: lng);
  }

  Future<void> updateGauge(final RainGauge updatedGauge) async {
    await ref.read(gaugesRepositoryProvider).updateGauge(updatedGauge);
  }

  Future<void> deleteGauge(final String gaugeId) async {
    await ref.read(gaugesRepositoryProvider).deleteGauge(gaugeId);
  }
}
