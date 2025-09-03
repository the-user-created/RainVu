import "package:drift/drift.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rain_gauges_dao.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart" as domain;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "gauges_repository.g.dart";

abstract class GaugesRepository {
  Stream<List<domain.RainGauge>> watchGauges();

  Future<List<domain.RainGauge>> fetchGauges();

  Future<void> addGauge({
    required final String name,
    final double? lat,
    final double? lng,
  });

  Future<void> updateGauge(final domain.RainGauge updatedGauge);

  Future<void> deleteGauge(final String gaugeId);
}

@Riverpod(keepAlive: true)
GaugesRepository gaugesRepository(final GaugesRepositoryRef ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftGaugesRepository(db.rainGaugesDao);
}

class DriftGaugesRepository implements GaugesRepository {
  DriftGaugesRepository(this._dao);

  final RainGaugesDao _dao;

  @override
  Stream<List<domain.RainGauge>> watchGauges() => _dao.watchAllGauges().map(
        (final gauges) => gauges.map(_mapDriftToDomain).toList(),
      );

  @override
  Future<List<domain.RainGauge>> fetchGauges() async {
    final List<RainGauge> gauges = await _dao.getAllGauges();
    return gauges.map(_mapDriftToDomain).toList();
  }

  @override
  Future<void> addGauge({
    required final String name,
    final double? lat,
    final double? lng,
  }) {
    final companion = RainGaugesCompanion.insert(
      name: name,
      latitude: Value(lat),
      longitude: Value(lng),
    );
    return _dao.insertGauge(companion);
  }

  @override
  Future<void> updateGauge(final domain.RainGauge updatedGauge) =>
      _dao.updateGauge(_mapDomainToCompanion(updatedGauge));

  @override
  Future<void> deleteGauge(final String gaugeId) =>
      _dao.deleteGauge(RainGaugesCompanion(id: Value(gaugeId)));

  domain.RainGauge _mapDriftToDomain(final RainGauge driftGauge) =>
      domain.RainGauge(
        id: driftGauge.id,
        name: driftGauge.name,
        latitude: driftGauge.latitude,
        longitude: driftGauge.longitude,
      );

  RainGaugesCompanion _mapDomainToCompanion(
    final domain.RainGauge domainGauge,
  ) =>
      RainGaugesCompanion(
        id: Value(domainGauge.id),
        name: Value(domainGauge.name),
        latitude: Value(domainGauge.latitude),
        longitude: Value(domainGauge.longitude),
      );
}
