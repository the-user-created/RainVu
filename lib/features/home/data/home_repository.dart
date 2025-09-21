import "package:intl/intl.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:rain_wise/shared/domain/rainfall_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "home_repository.g.dart";

abstract class HomeRepository {
  Stream<HomeData> watchHomeData();
}

@Riverpod(keepAlive: true)
HomeRepository homeRepository(final Ref ref) {
  final RainfallRepository rainfallRepo = ref.watch(rainfallRepositoryProvider);
  return DriftHomeRepository(rainfallRepo);
}

class DriftHomeRepository implements HomeRepository {
  DriftHomeRepository(this._rainfallRepo);

  final RainfallRepository _rainfallRepo;

  // This stream fires on any change to the rainfall_entries table.
  @override
  Stream<HomeData> watchHomeData() =>
      _rainfallRepo.watchTableUpdates().asyncMap((final _) async {
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month);
        final yearStart = DateTime(now.year);

        // Fetch all required data in parallel.
        final List<Object> results = await Future.wait([
          _rainfallRepo.getTotalAmountBetween(monthStart, now),
          _rainfallRepo.fetchRecentEntries(),
          _getMonthlyTrends(now),
          _rainfallRepo.getTotalAmountBetween(yearStart, now),
          _rainfallRepo.getTotalRainfall(),
          _rainfallRepo.getAvailableYears(),
        ]);

        final monthlyTotal = results[0] as double;
        final recentEntries = results[1] as List<RainfallEntry>;
        final monthlyTrends = results[2] as List<MonthlyTrendPoint>;
        final ytdTotal = results[3] as double;
        final totalRainfall = results[4] as double;
        final availableYears = results[5] as List<int>;

        final double annualAverage = availableYears.isNotEmpty
            ? totalRainfall / availableYears.toSet().length
            : 0.0;

        return HomeData(
          currentMonthDate: now,
          monthlyTotal: monthlyTotal,
          recentEntries: recentEntries,
          monthlyTrends: monthlyTrends,
          ytdTotal: ytdTotal,
          annualAverage: annualAverage,
        );
      });

  Future<List<MonthlyTrendPoint>> _getMonthlyTrends(final DateTime now) async {
    final twelveMonthsAgo = DateTime(now.year, now.month - 11);
    final List<MonthlyTotal> monthlyTotals = await _rainfallRepo
        .getMonthlyTotals(start: twelveMonthsAgo, end: now);

    final Map<String, double> trendsMap = {};
    for (int i = 0; i < 12; i++) {
      final monthDate = DateTime(now.year, now.month - i);
      final key = "${monthDate.year}-${monthDate.month}";
      trendsMap[key] = 0.0;
    }

    for (final total in monthlyTotals) {
      final key = "${total.year}-${total.month}";
      trendsMap[key] = total.total;
    }

    final trendPoints = <MonthlyTrendPoint>[];
    for (int i = 11; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i);
      final key = "${monthDate.year}-${monthDate.month}";
      trendPoints.add(
        MonthlyTrendPoint(
          month: DateFormat.MMM().format(monthDate),
          rainfall: trendsMap[key]!,
        ),
      );
    }

    return trendPoints;
  }
}
