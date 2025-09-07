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

// Helper class for monthly totals queries
class MonthlyTotal {
  MonthlyTotal(this.year, this.month, this.total);

  final int year;
  final int month;
  final double total;
}

// Helper class for yearly totals queries across several years
class YearlyTotal {
  YearlyTotal(this.year, this.total);

  final int year;
  final double total;
}

// Helper classes for monthly breakdown queries
class DailyTotal {
  DailyTotal(this.day, this.total);

  final int day;
  final double total;
}

class DailyHistoricalData {
  DailyHistoricalData(this.day, this.total, this.yearCount);

  final int day;
  final double total;
  final int yearCount;
}

// Helper for seasonal patterns queries
class DailyRainfall {
  DailyRainfall(this.date, this.total);

  final DateTime date;
  final double total;
}

// Helper for anomaly queries
class DailyTotalWithDate {
  DailyTotalWithDate(this.date, this.total);

  final DateTime date;
  final double total;
}

class HistoricalDayInfo {
  HistoricalDayInfo(this.month, this.day, this.total, this.yearCount);

  final int month;
  final int day;
  final double total;
  final int yearCount;
}

// Helper class for comparative analysis
class MonthlyTotalForYear {
  MonthlyTotalForYear(this.month, this.total);

  final int month;
  final double total;
}

@DriftAccessor(tables: [RainfallEntries, RainGauges])
class RainfallEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$RainfallEntriesDaoMixin {
  RainfallEntriesDao(super.attachedDatabase);

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

  Future<double> getTotalAmountBetween(
    final DateTime start,
    final DateTime end,
  ) async {
    final GeneratedColumn<double> amount = rainfallEntries.amount;
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([amount.sum()])
          ..where(rainfallEntries.date.isBetweenValues(start, end));
    final TypedResult result = await query.getSingle();
    return result.read(amount.sum()) ?? 0.0;
  }

  Future<List<int>> getAvailableYears() {
    final Expression<int> year = rainfallEntries.date.year;
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries, distinct: true)..addColumns([year]);
    return query.map((final row) => row.read(year)!).get();
  }

  Future<List<MonthlyTotalForYear>> getMonthlyTotalsForYear(final int year) {
    final Expression<int> month = rainfallEntries.date.month;
    final Expression<double> total = rainfallEntries.amount.sum();
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([month, total])
          ..where(rainfallEntries.date.year.equals(year))
          ..groupBy([month]);

    return query
        .map(
          (final row) =>
              MonthlyTotalForYear(row.read(month)!, row.read(total) ?? 0.0),
        )
        .get();
  }

  Future<double> getTotalRainfall() async {
    final GeneratedColumn<double> amount = rainfallEntries.amount;
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)..addColumns([amount.sum()]);
    final TypedResult result = await query.getSingle();
    return result.read(amount.sum()) ?? 0.0;
  }

  Future<int> getDistinctMonthCount() async {
    final Expression<int> year = rainfallEntries.date.year;
    final Expression<int> month = rainfallEntries.date.month;

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries, distinct: true)..addColumns([year, month]);

    final List<TypedResult> result = await query.get();
    return result.length;
  }

  Future<List<MonthlyTotal>> getMonthlyTotals({
    required final DateTime start,
    required final DateTime end,
  }) {
    final Expression<int> year = rainfallEntries.date.year;
    final Expression<int> month = rainfallEntries.date.month;
    final Expression<double> total = rainfallEntries.amount.sum();

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([year, month, total])
          ..where(rainfallEntries.date.isBetweenValues(start, end))
          ..groupBy([year, month])
          ..orderBy([OrderingTerm.asc(year), OrderingTerm.asc(month)]);

    return query
        .map(
          (final row) => MonthlyTotal(
            row.read(year)!,
            row.read(month)!,
            row.read(total) ?? 0.0,
          ),
        )
        .get();
  }

  Future<List<YearlyTotal>> getTotalsForMonthAcrossYears({
    required final int month,
    required final List<int> years,
  }) {
    final Expression<int> year = rainfallEntries.date.year;
    final Expression<double> total = rainfallEntries.amount.sum();

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([year, total])
          ..where(rainfallEntries.date.month.equals(month) & year.isIn(years))
          ..groupBy([year]);

    return query
        .map(
          (final row) => YearlyTotal(
            row.read(year)!,
            row.read(total) ?? 0.0,
          ),
        )
        .get();
  }

  Future<List<DailyTotal>> getDailyTotalsForMonth(
    final int year,
    final int month,
  ) {
    final Expression<int> day = rainfallEntries.date.day;
    final Expression<double> total = rainfallEntries.amount.sum();

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([day, total])
          ..where(
            rainfallEntries.date.year.equals(year) &
                rainfallEntries.date.month.equals(month),
          )
          ..groupBy([day]);

    return query
        .map((final row) => DailyTotal(row.read(day)!, row.read(total) ?? 0.0))
        .get();
  }

  Future<List<DailyHistoricalData>> getDailyHistoricalDataForMonth(
    final int month,
    final int excludeYear,
  ) {
    final Expression<int> day = rainfallEntries.date.day;
    final Expression<double> total = rainfallEntries.amount.sum();
    final Expression<int> yearCount =
        rainfallEntries.date.year.count(distinct: true);

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([day, total, yearCount])
          ..where(
            rainfallEntries.date.month.equals(month) &
                rainfallEntries.date.year.isNotValue(excludeYear),
          )
          ..groupBy([day]);

    return query
        .map(
          (final row) => DailyHistoricalData(
            row.read(day)!,
            row.read(total) ?? 0.0,
            row.read(yearCount)!,
          ),
        )
        .get();
  }

  Stream<void> watchTableUpdates() =>
      select(rainfallEntries).watch().map((final _) => {});

  Future<List<RainfallEntryWithGauge>> getRecentEntries({
    final int limit = 3,
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
        .get();
  }

  Future<List<DailyRainfall>> getDailyTotalsForSeason(
    final int year,
    final List<int> months,
  ) {
    // Group by the date part only (YYYY-MM-DD string) to aggregate
    // multiple entries on the same day.
    final Expression<String> dateStr =
        rainfallEntries.date.strftime("%Y-%m-%d");
    final Expression<double> total = rainfallEntries.amount.sum();

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([dateStr, total])
          ..where(
            rainfallEntries.date.year.equals(year) &
                rainfallEntries.date.month.isIn(months),
          )
          ..groupBy([dateStr]);

    return query.map((final row) {
      final DateTime date = DateTime.parse(row.read(dateStr)!);
      final double sum = row.read(total) ?? 0.0;
      return DailyRainfall(date, sum);
    }).get();
  }

  Future<List<YearlyTotal>> getHistoricalSeasonalTotals({
    required final List<int> months,
    required final int excludeYear,
  }) {
    final Expression<int> year = rainfallEntries.date.year;
    final Expression<double> total = rainfallEntries.amount.sum();

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([year, total])
          ..where(
            rainfallEntries.date.month.isIn(months) &
                year.isNotValue(excludeYear),
          )
          ..groupBy([year]);

    return query
        .map(
          (final row) => YearlyTotal(
            row.read(year)!,
            row.read(total) ?? 0.0,
          ),
        )
        .get();
  }

  Future<List<DailyTotalWithDate>> getDailyTotalsInRange(
    final DateTime start,
    final DateTime end,
  ) {
    final Expression<String> dateStr =
        rainfallEntries.date.strftime("%Y-%m-%d");
    final Expression<DateTime> minDate = rainfallEntries.date.min();
    final Expression<double> total = rainfallEntries.amount.sum();

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([minDate, total])
          ..where(rainfallEntries.date.isBetweenValues(start, end))
          ..groupBy([dateStr])
          ..orderBy([OrderingTerm.asc(minDate)]);

    return query
        .map(
          (final row) => DailyTotalWithDate(
            row.read(minDate)!,
            row.read(total) ?? 0.0,
          ),
        )
        .get();
  }

  Future<List<HistoricalDayInfo>> getHistoricalDayInfo() {
    final Expression<int> month = rainfallEntries.date.month;
    final Expression<int> day = rainfallEntries.date.day;
    final Expression<double> total = rainfallEntries.amount.sum();
    final Expression<int> yearCount =
        rainfallEntries.date.year.count(distinct: true);

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([month, day, total, yearCount])
          ..groupBy([month, day]);

    return query
        .map(
          (final row) => HistoricalDayInfo(
            row.read(month)!,
            row.read(day)!,
            row.read(total) ?? 0.0,
            row.read(yearCount)!,
          ),
        )
        .get();
  }

  Future<List<RainfallEntryWithGauge>> getEntriesWithGaugesInRange(
    final DateTime start,
    final DateTime end,
  ) {
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(rainfallEntries).join([
      leftOuterJoin(
        rainGauges,
        rainGauges.id.equalsExp(rainfallEntries.gaugeId),
      ),
    ])
          ..where(rainfallEntries.date.isBetweenValues(start, end))
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

  Future<List<RainfallEntryWithGauge>> getAllEntriesWithGauges() {
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(rainfallEntries).join([
      leftOuterJoin(
        rainGauges,
        rainGauges.id.equalsExp(rainfallEntries.gaugeId),
      ),
    ])
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

  Future<double> getSeasonalTotalForYear(
    final int year,
    final List<int> months,
  ) {
    final Expression<double> total = rainfallEntries.amount.sum();
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([total])
          ..where(
            rainfallEntries.date.year.equals(year) &
                rainfallEntries.date.month.isIn(months),
          );
    return query.map((final row) => row.read(total) ?? 0.0).getSingle();
  }
}
