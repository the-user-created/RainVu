import "package:drift/drift.dart";
import "package:rainly/app_constants.dart";
import "package:rainly/core/data/local/app_database.dart";
import "package:rainly/core/data/local/tables/rain_gauges.dart";
import "package:rainly/core/data/local/tables/rainfall_entries.dart";

part "rain_gauges_dao.g.dart";

class RainGaugeWithEntryCount {
  RainGaugeWithEntryCount(this.gauge, this.entryCount);

  final RainGauge gauge;
  final int entryCount;
}

@DriftAccessor(tables: [RainGauges, RainfallEntries])
class RainGaugesDao extends DatabaseAccessor<AppDatabase>
    with _$RainGaugesDaoMixin {
  RainGaugesDao(super.attachedDatabase);

  Stream<List<RainGaugeWithEntryCount>> watchAllGaugesWithEntryCount() {
    final Expression<int> entryCount = rainfallEntries.id.count();
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(rainGauges).join([
            leftOuterJoin(
              rainfallEntries,
              rainfallEntries.gaugeId.equalsExp(rainGauges.id),
            ),
          ])
          ..addColumns([entryCount])
          ..groupBy([rainGauges.id])
          ..orderBy([
            OrderingTerm(
              expression: CaseWhenExpression(
                cases: [
                  CaseWhen(
                    rainGauges.id.equals(AppConstants.defaultGaugeId),
                    then: const Constant(0),
                  ),
                ],
                orElse: const Constant(1),
              ),
            ),
            OrderingTerm.asc(rainGauges.name),
          ]);

    return query.watch().map(
      (final rows) => rows
          .map(
            (final row) => RainGaugeWithEntryCount(
              row.readTable(rainGauges),
              row.read(entryCount) ?? 0,
            ),
          )
          .toList(),
    );
  }

  Future<List<RainGaugeWithEntryCount>> getAllGaugesWithEntryCount() {
    final Expression<int> entryCount = rainfallEntries.id.count();
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(rainGauges).join([
            leftOuterJoin(
              rainfallEntries,
              rainfallEntries.gaugeId.equalsExp(rainGauges.id),
            ),
          ])
          ..addColumns([entryCount])
          ..groupBy([rainGauges.id])
          ..orderBy([
            OrderingTerm(
              expression: CaseWhenExpression(
                cases: [
                  CaseWhen(
                    rainGauges.id.equals(AppConstants.defaultGaugeId),
                    then: const Constant(0),
                  ),
                ],
                orElse: const Constant(1),
              ),
            ),
            OrderingTerm.asc(rainGauges.name),
          ]);

    return query
        .map(
          (final row) => RainGaugeWithEntryCount(
            row.readTable(rainGauges),
            row.read(entryCount) ?? 0,
          ),
        )
        .get();
  }

  Stream<List<RainGauge>> watchAllGauges() => (select(
    rainGauges,
  )..orderBy([(final t) => OrderingTerm(expression: t.name)])).watch();

  Future<List<RainGauge>> getAllGauges() => (select(
    rainGauges,
  )..orderBy([(final t) => OrderingTerm(expression: t.name)])).get();

  Future<RainGauge?> getGaugeById(final String id) => (select(
    rainGauges,
  )..where((final tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<RainGauge?> findGaugeByName(final String name) => (select(
    rainGauges,
  )..where((final tbl) => tbl.name.equals(name))).getSingleOrNull();

  Future<void> insertGauge(final Insertable<RainGauge> gauge) =>
      into(rainGauges).insert(gauge);

  Future<void> insertGauges(final List<Insertable<RainGauge>> gauges) =>
      batch((final b) => b.insertAll(rainGauges, gauges));

  Future<bool> updateGauge(final Insertable<RainGauge> gauge) =>
      update(rainGauges).replace(gauge);

  Future<int> deleteGauge(final Insertable<RainGauge> gauge) =>
      delete(rainGauges).delete(gauge);
}
