import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "gauges_repository.g.dart";

abstract class GaugesRepository {
  Future<List<RainGauge>> fetchGauges();

  Future<void> addGauge({required final String name});

  Future<void> updateGauge(final RainGauge updatedGauge);

  Future<void> deleteGauge(final String gaugeId);
}

@Riverpod(keepAlive: true)
GaugesRepository gaugesRepository(final GaugesRepositoryRef ref) =>
    MockGaugesRepository();

class MockGaugesRepository implements GaugesRepository {
  final List<RainGauge> _gauges = [
    const RainGauge(id: "1", name: "Backyard Gauge"),
    const RainGauge(id: "2", name: "Garden Plot A"),
    const RainGauge(id: "3", name: "Rooftop Collector"),
  ];

  @override
  Future<List<RainGauge>> fetchGauges() async {
    // In a real app, this would fetch from Firestore or another data source.
    await Future.delayed(const Duration(seconds: 1));
    return _gauges;
  }

  @override
  Future<void> addGauge({required final String name}) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    _gauges.add(RainGauge(id: DateTime.now().toIso8601String(), name: name));
  }

  @override
  Future<void> updateGauge(final RainGauge updatedGauge) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    final int index = _gauges.indexWhere((final g) => g.id == updatedGauge.id);
    if (index != -1) {
      _gauges[index] = updatedGauge;
    }
  }

  @override
  Future<void> deleteGauge(final String gaugeId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    _gauges.removeWhere((final g) => g.id == gaugeId);
  }
}
