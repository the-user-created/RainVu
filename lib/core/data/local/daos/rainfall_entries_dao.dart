import "package:collection/collection.dart";
import "package:drift/drift.dart";
import "package:rainvu/core/data/local/app_database.dart";
import "package:rainvu/core/data/local/tables/rain_gauges.dart";
import "package:rainvu/core/data/local/tables/rainfall_entries.dart";
import "package:rainvu/core/utils/extensions.dart";

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

// Helper for historical daily data queries
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

// Helper class for historical day info queries
class HistoricalDayInfo {
  HistoricalDayInfo(this.month, this.day, this.total, this.yearCount);

  final int month;
  final int day;
  final double total;
  final int yearCount;
}

// Helper class for yearly comparison
class MonthlyTotalForYear {
  MonthlyTotalForYear(this.month, this.total);

  final int month;
  final double total;
}

// Helper class for date range queries
class DateRangeResult {
  DateRangeResult(this.min, this.max);

  final DateTime? min;
  final DateTime? max;
}

@DriftAccessor(tables: [RainfallEntries, RainGauges])
class RainfallEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$RainfallEntriesDaoMixin {
  RainfallEntriesDao(super.attachedDatabase);

  Future<void> insertEntry(final Insertable<RainfallEntry> entry) =>
      into(rainfallEntries).insert(entry);

  Future<void> upsertEntries(final List<Insertable<RainfallEntry>> entries) =>
      batch(
        (final b) => b.insertAll(
          rainfallEntries,
          entries,
          mode: InsertMode.insertOrReplace,
        ),
      );

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

  Stream<List<RainfallEntryWithGauge>> watchEntriesForMonth(
    final DateTime month, {
    final String? gaugeId,
  }) {
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(rainfallEntries).join([
          leftOuterJoin(
            rainGauges,
            rainGauges.id.equalsExp(rainfallEntries.gaugeId),
          ),
        ]);

    Expression<bool> whereClause =
        rainfallEntries.date.year.equals(month.year) &
        rainfallEntries.date.month.equals(month.month);

    if (gaugeId != null) {
      whereClause = whereClause & rainfallEntries.gaugeId.equals(gaugeId);
    }

    query
      ..where(whereClause)
      ..orderBy([OrderingTerm.desc(rainfallEntries.date)]);

    return query
        .map(
          (final row) => RainfallEntryWithGauge(
            entry: row.readTable(rainfallEntries),
            gauge: row.readTableOrNull(rainGauges),
          ),
        )
        .watch();
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
    final DateTime end, {
    final String? gaugeId,
  }) async {
    final List<DailyTotalWithDate> dailyTotals = await getDailyTotalsInRange(
      start,
      end,
      gaugeId: gaugeId,
    );
    return dailyTotals.map((final e) => e.total).sum;
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

  Future<double> getYearlyTotal(final int year) async {
    final DateTime start = DateTime(year);
    final DateTime end = DateTime(year, 12, 31).endOfDay;
    final List<DailyTotalWithDate> dailyTotals = await getDailyTotalsInRange(
      start,
      end,
    );
    return dailyTotals.map((final e) => e.total).sum;
  }

  Future<double> getTotalRainfall() async {
    final DateRangeResult range = await getDateRangeOfEntries();
    if (range.min == null || range.max == null) {
      return 0.0;
    }
    final List<DailyTotalWithDate> dailyTotals = await getDailyTotalsInRange(
      range.min!,
      range.max!,
    );
    return dailyTotals.map((final e) => e.total).sum;
  }

  Future<List<MonthlyTotal>> getAllMonthlyTotals() {
    final Expression<int> year = rainfallEntries.date.year;
    final Expression<int> month = rainfallEntries.date.month;
    final Expression<double> total = rainfallEntries.amount.sum();

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([year, month, total])
          ..groupBy([year, month]);

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

  Future<List<MonthlyTotal>> getMonthlyTotals({
    required final DateTime start,
    required final DateTime end,
  }) async {
    final List<DailyTotalWithDate> dailyTotals = await getDailyTotalsInRange(
      start,
      end,
    );
    final Map<(int, int), double> monthlyMap = {};

    for (final daily in dailyTotals) {
      final (int, int) key = (daily.date.year, daily.date.month);
      monthlyMap.update(
        key,
        (final value) => value + daily.total,
        ifAbsent: () => daily.total,
      );
    }

    final List<MonthlyTotal> result =
        monthlyMap.entries
            .map((final e) => MonthlyTotal(e.key.$1, e.key.$2, e.value))
            .toList()
          ..sort((final a, final b) {
            if (a.year != b.year) {
              return a.year.compareTo(b.year);
            }
            return a.month.compareTo(b.month);
          });

    return result;
  }

  Future<List<YearlyTotal>> getTotalsForMonthAcrossYears({
    required final int month,
    required final List<int> years,
    final String? gaugeId,
  }) {
    final Expression<int> year = rainfallEntries.date.year;
    final Expression<double> total = rainfallEntries.amount.sum();

    Expression<bool> whereClause =
        rainfallEntries.date.month.equals(month) & year.isIn(years);
    if (gaugeId != null) {
      whereClause = whereClause & rainfallEntries.gaugeId.equals(gaugeId);
    }

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([year, total])
          ..where(whereClause)
          ..groupBy([year]);

    return query
        .map(
          (final row) => YearlyTotal(row.read(year)!, row.read(total) ?? 0.0),
        )
        .get();
  }

  Future<List<DailyTotal>> getDailyTotalsForMonth(
    final int year,
    final int month, {
    final String? gaugeId,
  }) {
    final Expression<int> dayExp = rainfallEntries.date.day;
    final Expression<bool> monthClause =
        rainfallEntries.date.year.equals(year) &
        rainfallEntries.date.month.equals(month);

    // If a specific gauge is selected, we can use a simpler sum query.
    if (gaugeId != null) {
      final Expression<double> totalExp = rainfallEntries.amount.sum();
      final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
          selectOnly(rainfallEntries)
            ..addColumns([dayExp, totalExp])
            ..where(monthClause & rainfallEntries.gaugeId.equals(gaugeId))
            ..groupBy([dayExp]);

      return query
          .map(
            (final row) =>
                DailyTotal(row.read(dayExp)!, row.read(totalExp) ?? 0.0),
          )
          .get();
    }

    // Original query for 'All Gauges' that averages across multiple gauges
    final Expression<double> gaugeTotalExp = rainfallEntries.amount.sum();

    // 1. Inner query: sum per gauge per day
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry>
    dailyPerGauge = selectOnly(rainfallEntries)
      ..addColumns([dayExp, gaugeTotalExp])
      ..where(monthClause)
      ..groupBy([dayExp, rainfallEntries.gaugeId]);

    // 2. Wrap in subquery to do the averaging
    final Subquery<TypedResult> sub = Subquery(
      dailyPerGauge,
      "daily_per_gauge",
    );
    final Expression<int> dayFromSub = sub.ref(dayExp);
    final Expression<double> gaugeTotalFromSub = sub.ref(gaugeTotalExp);
    final Expression<double> avgDailyTotalExp = gaugeTotalFromSub.avg();

    final JoinedSelectStatement<Subquery, TypedResult> query = selectOnly(sub)
      ..addColumns([dayFromSub, avgDailyTotalExp])
      ..groupBy([dayFromSub]);

    return query
        .map(
          (final row) => DailyTotal(
            row.read(dayFromSub)!,
            row.read(avgDailyTotalExp) ?? 0.0,
          ),
        )
        .get();
  }

  Future<List<DailyHistoricalData>> getDailyHistoricalDataForMonth(
    final int month,
    final int excludeYear,
  ) {
    final Expression<int> day = rainfallEntries.date.day;
    final Expression<double> total = rainfallEntries.amount.sum();
    final Expression<int> yearCount = rainfallEntries.date.year.count(
      distinct: true,
    );

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

  Future<List<RainfallEntryWithGauge>> getRecentEntries({final int limit = 3}) {
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
    final List<int> months, {
    final String? gaugeId,
  }) {
    final Expression<String> dateStrExp = rainfallEntries.date.strftime(
      "%Y-%m-%d",
    );

    Expression<bool> whereClause =
        rainfallEntries.date.year.equals(year) &
        rainfallEntries.date.month.isIn(months);

    if (gaugeId != null) {
      // Simple sum for a single gauge
      final Expression<double> totalExp = rainfallEntries.amount.sum();
      whereClause = whereClause & rainfallEntries.gaugeId.equals(gaugeId);

      final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
          selectOnly(rainfallEntries)
            ..addColumns([dateStrExp, totalExp])
            ..where(whereClause)
            ..groupBy([dateStrExp]);

      return query
          .map(
            (final row) => DailyRainfall(
              DateTime.parse(row.read(dateStrExp)!),
              row.read(totalExp) ?? 0.0,
            ),
          )
          .get();
    }

    // "All Gauges" logic: average across gauges for each day
    final Expression<double> gaugeTotalExp = rainfallEntries.amount.sum();

    // 1. Inner query: sum per gauge per day
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry>
    dailyPerGauge = selectOnly(rainfallEntries)
      ..addColumns([dateStrExp, gaugeTotalExp])
      ..where(whereClause)
      ..groupBy([dateStrExp, rainfallEntries.gaugeId]);

    // 2. Wrap in subquery to do the averaging
    final Subquery<TypedResult> sub = Subquery(
      dailyPerGauge,
      "daily_per_gauge",
    );
    final Expression<String> dateStrFromSub = sub.ref(dateStrExp);
    final Expression<double> gaugeTotalFromSub = sub.ref(gaugeTotalExp);
    final Expression<double> avgDailyTotalExp = gaugeTotalFromSub.avg();

    final JoinedSelectStatement<Subquery, TypedResult> query = selectOnly(sub)
      ..addColumns([dateStrFromSub, avgDailyTotalExp])
      ..groupBy([dateStrFromSub]);

    return query.map((final row) {
      final DateTime date = DateTime.parse(row.read(dateStrFromSub)!);
      final double sum = row.read(avgDailyTotalExp) ?? 0.0;
      return DailyRainfall(date, sum);
    }).get();
  }

  Future<List<YearlyTotal>> getHistoricalSeasonalTotals({
    required final List<int> months,
    required final int excludeYear,
    final String? gaugeId,
  }) {
    final Expression<int> year = rainfallEntries.date.year;
    final Expression<double> total = rainfallEntries.amount.sum();

    Expression<bool> whereClause =
        rainfallEntries.date.month.isIn(months) & year.isNotValue(excludeYear);

    if (gaugeId != null) {
      whereClause = whereClause & rainfallEntries.gaugeId.equals(gaugeId);
    }

    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([year, total])
          ..where(whereClause)
          ..groupBy([year]);

    return query
        .map(
          (final row) => YearlyTotal(row.read(year)!, row.read(total) ?? 0.0),
        )
        .get();
  }

  Future<List<DailyTotalWithDate>> getDailyTotalsInRange(
    final DateTime start,
    final DateTime end, {
    final String? gaugeId,
  }) {
    final Expression<String> dateStrExp = rainfallEntries.date.strftime(
      "%Y-%m-%d",
    );
    final Expression<DateTime> minDateExp = rainfallEntries.date.min();

    if (gaugeId != null) {
      // Simple sum for a single gauge
      final Expression<double> totalExp = rainfallEntries.amount.sum();
      final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
          selectOnly(rainfallEntries)
            ..addColumns([minDateExp, totalExp])
            ..where(
              rainfallEntries.date.isBetweenValues(start, end) &
                  rainfallEntries.gaugeId.equals(gaugeId),
            )
            ..groupBy([dateStrExp])
            ..orderBy([OrderingTerm.asc(minDateExp)]);

      return query
          .map(
            (final row) => DailyTotalWithDate(
              row.read(minDateExp)!,
              row.read(totalExp) ?? 0.0,
            ),
          )
          .get();
    }

    // "All Gauges" logic: average across gauges for each day
    final Expression<double> gaugeTotalExp = rainfallEntries.amount.sum();

    // 1. Inner query: sum per gauge per day
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry>
    dailyPerGauge = selectOnly(rainfallEntries)
      ..addColumns([dateStrExp, minDateExp, gaugeTotalExp])
      ..where(rainfallEntries.date.isBetweenValues(start, end))
      ..groupBy([dateStrExp, rainfallEntries.gaugeId]);

    // 2. Wrap in subquery for averaging
    final Subquery<TypedResult> sub = Subquery(
      dailyPerGauge,
      "daily_per_gauge",
    );
    final Expression<DateTime> minDateFromSub = sub.ref(minDateExp);
    final Expression<String> dateStrFromSub = sub.ref(dateStrExp);
    final Expression<double> gaugeTotalFromSub = sub.ref(gaugeTotalExp);
    final Expression<double> avgDailyTotalExp = gaugeTotalFromSub.avg();

    final JoinedSelectStatement<Subquery, TypedResult> query = selectOnly(sub)
      ..addColumns([minDateFromSub, avgDailyTotalExp])
      ..groupBy([dateStrFromSub])
      ..orderBy([OrderingTerm.asc(minDateFromSub)]);

    return query
        .map(
          (final row) => DailyTotalWithDate(
            row.read(minDateFromSub)!,
            row.read(avgDailyTotalExp) ?? 0.0,
          ),
        )
        .get();
  }

  Future<List<HistoricalDayInfo>> getHistoricalDayInfo() {
    final Expression<int> month = rainfallEntries.date.month;
    final Expression<int> day = rainfallEntries.date.day;
    final Expression<double> total = rainfallEntries.amount.sum();
    final Expression<int> yearCount = rainfallEntries.date.year.count(
      distinct: true,
    );

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

  Future<List<RainfallEntry>> getAllEntries() => select(rainfallEntries).get();

  Future<List<RainfallEntryWithGauge>> getAllEntriesWithGauges() {
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(rainfallEntries).join([
          leftOuterJoin(
            rainGauges,
            rainGauges.id.equalsExp(rainfallEntries.gaugeId),
          ),
        ])..orderBy([OrderingTerm.desc(rainfallEntries.date)]);

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

  Future<int> countEntriesForGauge(final String gaugeId) async {
    final Expression<int> countExp = rainfallEntries.id.count();
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)
          ..addColumns([countExp])
          ..where(rainfallEntries.gaugeId.equals(gaugeId));
    final TypedResult result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<int> reassignEntries(
    final String fromGaugeId,
    final String toGaugeId,
  ) =>
      (update(rainfallEntries)
            ..where((final tbl) => tbl.gaugeId.equals(fromGaugeId)))
          .write(RainfallEntriesCompanion(gaugeId: Value(toGaugeId)));

  Future<int> deleteEntriesForGauge(final String gaugeId) => (delete(
    rainfallEntries,
  )..where((final tbl) => tbl.gaugeId.equals(gaugeId))).go();

  Future<DateRangeResult> getDateRangeOfEntries() async {
    final Expression<DateTime> minDate = rainfallEntries.date.min();
    final Expression<DateTime> maxDate = rainfallEntries.date.max();
    final JoinedSelectStatement<$RainfallEntriesTable, RainfallEntry> query =
        selectOnly(rainfallEntries)..addColumns([minDate, maxDate]);
    final TypedResult result = await query.getSingle();
    return DateRangeResult(result.read(minDate), result.read(maxDate));
  }
}
