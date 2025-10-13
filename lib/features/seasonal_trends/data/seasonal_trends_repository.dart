import "dart:math";

import "package:collection/collection.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/seasonal_trends/application/seasonal_trends_provider.dart";
import "package:rain_wise/features/seasonal_trends/domain/seasonal_trends_data.dart";
import "package:rain_wise/shared/domain/seasons.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "seasonal_trends_repository.g.dart";

abstract class SeasonalTrendsRepository {
  Future<SeasonalTrendsData> fetchSeasonalTrends(
    final SeasonalFilter filter,
    final Hemisphere hemisphere,
  );
}

@riverpod
SeasonalTrendsRepository seasonalTrendsRepository(final Ref ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftSeasonalTrendsRepository(db.rainfallEntriesDao);
}

class DriftSeasonalTrendsRepository implements SeasonalTrendsRepository {
  DriftSeasonalTrendsRepository(this._dao);

  final RainfallEntriesDao _dao;

  @override
  Future<SeasonalTrendsData> fetchSeasonalTrends(
    final SeasonalFilter filter,
    final Hemisphere hemisphere,
  ) async {
    final List<int> months = getMonthsForSeason(filter.season, hemisphere);

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

    // --- Process Data for Chart ---
    final Map<DateTime, double> dailyTotalsMap = {
      for (final item in dailyTotalsForSeason) item.date: item.total,
    };

    final List<SeasonalTrendPoint> trendData = [];
    // Generate a point for every day of the season to create a continuous chart,
    // even if there is no rainfall data. This ensures the chart always renders correctly.
    for (final month in months) {
      final int daysInMonth = DateTime(filter.year, month + 1, 0).day;
      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(filter.year, month, day);
        trendData.add(
          SeasonalTrendPoint(date: date, rainfall: dailyTotalsMap[date] ?? 0.0),
        );
      }
    }
    // Ensure data is sorted by date, especially for non-contiguous seasons like Winter.
    trendData.sort((final a, final b) => a.date.compareTo(b.date));

    // If there's no data at all, return a zeroed-out state with complete trend data.
    if (dailyTotalsForSeason.isEmpty && historicalTotals.isEmpty) {
      return SeasonalTrendsData(
        summary: const SeasonalSummary(
          averageRainfall: 0,
          trendVsHistory: 0,
          highestRecorded: 0,
          lowestRecorded: 0,
        ),
        trendData: trendData,
      );
    }

    // --- Process Data for Summary Card ---
    final double totalRainfallThisSeason = dailyTotalsForSeason
        .map((final e) => e.total)
        .sum;

    final Iterable<DailyRainfall> rainyDays = dailyTotalsForSeason.where(
      (final e) => e.total > 0,
    );
    final double highestRecorded = rainyDays.isEmpty
        ? 0.0
        : rainyDays.map((final e) => e.total).reduce(max);
    final double lowestRecorded = rainyDays.isEmpty
        ? 0.0
        : rainyDays.map((final e) => e.total).reduce(min);

    double historicalAverage = 0;
    if (historicalTotals.isNotEmpty) {
      final double historicalTotalSum = historicalTotals
          .map((final e) => e.total)
          .sum;
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

    final double averageRainfall = trendData.isEmpty
        ? 0.0
        : totalRainfallThisSeason / trendData.length;

    final summary = SeasonalSummary(
      averageRainfall: averageRainfall,
      trendVsHistory: trendVsHistory,
      highestRecorded: highestRecorded,
      lowestRecorded: lowestRecorded,
    );

    return SeasonalTrendsData(summary: summary, trendData: trendData);
  }
}
