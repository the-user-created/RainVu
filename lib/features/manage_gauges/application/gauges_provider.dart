import "dart:async";

import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/manage_gauges/data/gauges_repository.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "gauges_provider.g.dart";

@riverpod
class Gauges extends _$Gauges {
  @override
  FutureOr<List<RainGauge>> build() =>
      ref.watch(gaugesRepositoryProvider).fetchGauges();

  Future<void> addGauge({required final String name}) async {
    final GaugesRepository repo = ref.read(gaugesRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.addGauge(name: name);
      return repo.fetchGauges();
    });
  }

  Future<void> updateGauge(final RainGauge updatedGauge) async {
    final GaugesRepository repo = ref.read(gaugesRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.updateGauge(updatedGauge);
      return repo.fetchGauges();
    });
  }

  Future<void> deleteGauge(final String gaugeId) async {
    final GaugesRepository repo = ref.read(gaugesRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.deleteGauge(gaugeId);
      return repo.fetchGauges();
    });
  }
}
