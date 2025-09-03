import "package:drift/drift.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/tables/rain_gauges.dart";

part "rain_gauges_dao.g.dart";

@DriftAccessor(tables: [RainGauges])
class RainGaugesDao extends DatabaseAccessor<AppDatabase>
    with _$RainGaugesDaoMixin {
  RainGaugesDao(super.attachedDatabase);

  Stream<List<RainGauge>> watchAllGauges() => (select(rainGauges)
        ..orderBy([(final t) => OrderingTerm(expression: t.name)]))
      .watch();

  Future<List<RainGauge>> getAllGauges() => (select(rainGauges)
        ..orderBy([(final t) => OrderingTerm(expression: t.name)]))
      .get();

  Future<RainGauge?> findGaugeByName(final String name) =>
      (select(rainGauges)..where((final tbl) => tbl.name.equals(name)))
          .getSingleOrNull();

  Future<void> insertGauge(final Insertable<RainGauge> gauge) =>
      into(rainGauges).insert(gauge);

  Future<void> insertGauges(final List<Insertable<RainGauge>> gauges) =>
      batch((final b) => b.insertAll(rainGauges, gauges));

  Future<bool> updateGauge(final Insertable<RainGauge> gauge) =>
      update(rainGauges).replace(gauge);

  Future<int> deleteGauge(final Insertable<RainGauge> gauge) =>
      delete(rainGauges).delete(gauge);
}
