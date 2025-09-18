import "dart:math";

import "package:collection/collection.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/seasonal_patterns/application/seasonal_patterns_provider.dart";
import "package:rain_wise/features/seasonal_patterns/domain/seasonal_patterns_data.dart";
import "package:rain_wise/shared/domain/seasons.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "seasonal_patterns_repository.g.dart";

abstract class SeasonalPatternsRepository {
  Future<SeasonalPatternsData> fetchSeasonalPatterns(
    final SeasonalFilter filter,
  );
}

@riverpod
SeasonalPatternsRepository seasonalPatternsRepository(
  final Ref ref,
) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftSeasonalPatternsRepository(db.rainfallEntriesDao);
}

class DriftSeasonalPatternsRepository implements SeasonalPatternsRepository {
  DriftSeasonalPatternsRepository(this._dao);

  final RainfallEntriesDao _dao;

  /// Maps a [Season] enum to a list of corresponding month integers.
  /// TODO: should use the user's locale to determine the start of seasons.
  List<int> _getMonthsForSeason(final Season season) {
    switch (season) {
      case Season.spring:
        return [3, 4, 5]; // Mar, Apr, May
      case Season.summer:
        return [6, 7, 8]; // Jun, Jul, Aug
      case Season.autumn:
        return [9, 10, 11]; // Sep, Oct, Nov
      case Season.winter:
        return [12, 1, 2]; // Dec, Jan, Feb
    }
  }

  @override
  Future<SeasonalPatternsData> fetchSeasonalPatterns(
    final SeasonalFilter filter,
  ) async {
    final List<int> months = _getMonthsForSeason(filter.season);

    // Fetch data for the selected season and its historical counterparts in parallel.
    final List<List<Object>> results = await Future.wait([
      _dao.getDailyTotalsForSeason(filter.year, months),
      _dao.getHistoricalSeasonalTotals(
        months: months,
        excludeYear: filter.year,
      ),
    ]);

    final dailyTotalsForSeason = results[0] as List<DailyRainfall>;
    final historicalTotals = results[1] as List<YearlyTotal>;

    // If there's no data at all, return an empty state.
    if (dailyTotalsForSeason.isEmpty && historicalTotals.isEmpty) {
      return const SeasonalPatternsData(
        summary: SeasonalSummary(
          averageRainfall: 0,
          trendVsHistory: 0,
          highestRecorded: 0,
          lowestRecorded: 0,
        ),
        trendData: [],
      );
    }

    // --- Process Data for Chart ---
    final Map<DateTime, double> dailyTotalsMap = {
      for (final item in dailyTotalsForSeason) item.date: item.total,
    };

    final List<SeasonalTrendPoint> trendData = [];
    // Generate a point for every day of the season to create a continuous chart.
    for (final month in months) {
      final int daysInMonth = DateTime(filter.year, month + 1, 0).day;
      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(filter.year, month, day);
        trendData.add(
          SeasonalTrendPoint(
            date: date,
            rainfall: dailyTotalsMap[date] ?? 0.0,
          ),
        );
      }
    }
    // Ensure data is sorted by date, especially for non-contiguous seasons like Winter.
    trendData.sort((final a, final b) => a.date.compareTo(b.date));

    // --- Process Data for Summary Card ---
    final double totalRainfallThisSeason =
        dailyTotalsForSeason.map((final e) => e.total).sum;

    final Iterable<DailyRainfall> rainyDays =
        dailyTotalsForSeason.where((final e) => e.total > 0);
    final double highestRecorded = rainyDays.isEmpty
        ? 0.0
        : rainyDays.map((final e) => e.total).reduce(max);
    final double lowestRecorded = rainyDays.isEmpty
        ? 0.0
        : rainyDays.map((final e) => e.total).reduce(min);

    double historicalAverage = 0;
    if (historicalTotals.isNotEmpty) {
      final double historicalTotalSum =
          historicalTotals.map((final e) => e.total).sum;
      historicalAverage = historicalTotalSum / historicalTotals.length;
    }

    double trendVsHistory = 0;
    if (historicalAverage > 0) {
      trendVsHistory =
          ((totalRainfallThisSeason - historicalAverage) / historicalAverage) *
              100;
    } else if (totalRainfallThisSeason > 0) {
      trendVsHistory = 100; // From 0 to a positive value
    }

    final double averageRainfall =
        trendData.isEmpty ? 0.0 : totalRainfallThisSeason / trendData.length;

    final summary = SeasonalSummary(
      averageRainfall: averageRainfall,
      trendVsHistory: trendVsHistory,
      highestRecorded: highestRecorded,
      lowestRecorded: lowestRecorded,
    );

    return SeasonalPatternsData(summary: summary, trendData: trendData);
  }
}
