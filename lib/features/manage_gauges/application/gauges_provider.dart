import "dart:async";

import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "gauges_provider.g.dart";

@riverpod
class Gauges extends _$Gauges {
  // Mock repository method
  Future<List<RainGauge>> _fetchGauges() async {
    // In a real app, this would fetch from Firestore or another data source.
    await Future.delayed(const Duration(seconds: 1));
    return [
      const RainGauge(id: "1", name: "Backyard Gauge"),
      const RainGauge(id: "2", name: "Garden Plot A"),
      const RainGauge(id: "3", name: "Rooftop Collector"),
    ];
  }

  @override
  FutureOr<List<RainGauge>> build() => _fetchGauges();

  Future<void> addGauge({required final String name}) async {
    // Note: Using `await future` is safer as it handles both sync and async states.
    final List<RainGauge> oldState = await future;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        ...oldState,
        RainGauge(id: DateTime.now().toIso8601String(), name: name),
      ];
    });
  }

  Future<void> updateGauge(final RainGauge updatedGauge) async {
    final List<RainGauge> oldState = await future;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        for (final gauge in oldState)
          if (gauge.id == updatedGauge.id) updatedGauge else gauge,
      ];
    });
  }

  Future<void> deleteGauge(final String gaugeId) async {
    final List<RainGauge> oldState = await future;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      return oldState.where((final g) => g.id != gaugeId).toList();
    });
  }
}
