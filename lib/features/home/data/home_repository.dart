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
        final today = DateTime(now.year, now.month, now.day);
        final monthStart = DateTime(now.year, now.month);
        // Assuming Monday is the start of the week (weekday == 1).
        final DateTime weekStart = today.subtract(
          Duration(days: now.weekday - 1),
        );

        // Fetch all required data in parallel.
        final List<Object> results = await Future.wait([
          _rainfallRepo.getTotalAmountBetween(monthStart, now),
          _rainfallRepo.getTotalAmountBetween(weekStart, now),
          _rainfallRepo.fetchRecentEntries(),
          _getMonthlyTrends(now),
        ]);

        final monthlyTotal = results[0] as double;
        final weeklyTotal = results[1] as double;
        final recentEntries = results[2] as List<RainfallEntry>;
        final monthlyTrends = results[3] as List<MonthlyTrendPoint>;

        final double dailyAvg = now.day > 0 ? monthlyTotal / now.day : 0.0;

        return HomeData(
          currentMonthDate: now,
          monthlyTotal: monthlyTotal,
          recentEntries: recentEntries,
          quickStats: [
            QuickStat(value: weeklyTotal, type: QuickStatType.thisWeek),
            QuickStat(value: monthlyTotal, type: QuickStatType.thisMonth),
            QuickStat(value: dailyAvg, type: QuickStatType.dailyAvg),
          ],
          monthlyTrends: monthlyTrends,
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
