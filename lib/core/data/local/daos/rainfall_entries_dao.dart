import "package:drift/drift.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/tables/rain_gauges.dart";
import "package:rain_wise/core/data/local/tables/rainfall_entries.dart";

part "rainfall_entries_dao.g.dart";

class RainfallEntryWithGauge {
  RainfallEntryWithGauge({required this.entry, this.gauge});

  final RainfallEntry entry;
  final RainGauge? gauge;
}

@DriftAccessor(tables: [RainfallEntries, RainGauges])
class RainfallEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$RainfallEntriesDaoMixin {
  RainfallEntriesDao(super.attachedDatabase);

  // Basic CRUD
  Future<void> insertEntry(final Insertable<RainfallEntry> entry) =>
      into(rainfallEntries).insert(entry);

  Future<void> insertEntries(final List<Insertable<RainfallEntry>> entries) =>
      batch((final b) => b.insertAll(rainfallEntries, entries));

  Future<bool> updateEntry(final Insertable<RainfallEntry> entry) =>
      update(rainfallEntries).replace(entry);

  Future<int> deleteEntry(final Insertable<RainfallEntry> entry) =>
      delete(rainfallEntries).delete(entry);

  Future<int> deleteAllEntries() => delete(rainfallEntries).go();

  // Complex queries
  Future<List<RainfallEntryWithGauge>> getEntriesForMonth(
    final DateTime month,
  ) {
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(rainfallEntries).join([
      leftOuterJoin(
        rainGauges,
        rainGauges.id.equalsExp(rainfallEntries.gaugeId),
      ),
    ])
          ..where(
            rainfallEntries.date.year.equals(month.year) &
                rainfallEntries.date.month.equals(month.month),
          )
          ..orderBy([OrderingTerm.desc(rainfallEntries.date)]);

    return query
        .map(
          (final row) => RainfallEntryWithGauge(
            entry: row.readTable(rainfallEntries),
            gauge: row.readTableOrNull(rainGauges),
          ),
        )
        .get();
  }

  Stream<List<RainfallEntryWithGauge>> watchRecentEntries({
    final int limit = 5,
  }) {
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(rainfallEntries).join([
      leftOuterJoin(
        rainGauges,
        rainGauges.id.equalsExp(rainfallEntries.gaugeId),
      ),
    ])
          ..orderBy([OrderingTerm.desc(rainfallEntries.date)])
          ..limit(limit);

    return query
        .map(
          (final row) => RainfallEntryWithGauge(
            entry: row.readTable(rainfallEntries),
            gauge: row.readTableOrNull(rainGauges),
          ),
        )
        .watch();
  }

  Future<List<int>> getAvailableYears() {
    final Expression<int> year = rainfallEntries.date.year;
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries, distinct: true)..addColumns([year]);
    return query.map((final row) => row.read(year)!).get();
  }

  Future<List<TypedResult>> getMonthlyTotalsForYear(final int year) {
    final Expression<int> month = rainfallEntries.date.month;
    final Expression<double> total = rainfallEntries.amount.sum();
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([month, total])
          ..where(rainfallEntries.date.year.equals(year))
          ..groupBy([month]);

    return query.get();
  }
}
