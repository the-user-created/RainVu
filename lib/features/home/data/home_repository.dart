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
        final DateTime weekStart =
            today.subtract(Duration(days: now.weekday - 1));

        // Fetch all required data in parallel.
        final List<Object> results = await Future.wait([
          _rainfallRepo.getTotalAmountBetween(monthStart, now),
          _rainfallRepo.getTotalAmountBetween(weekStart, now),
          _rainfallRepo.fetchRecentEntries(),
        ]);

        final monthlyTotal = results[0] as double;
        final weeklyTotal = results[1] as double;
        final recentEntries = results[2] as List<RainfallEntry>;

        final double dailyAvg = now.day > 0 ? monthlyTotal / now.day : 0.0;

        return HomeData(
          currentMonthDate: now,
          monthlyTotal: monthlyTotal,
          recentEntries: recentEntries,
          quickStats: [
            QuickStat(
              value: weeklyTotal,
              type: QuickStatType.thisWeek,
            ),
            QuickStat(
              value: monthlyTotal,
              type: QuickStatType.thisMonth,
            ),
            QuickStat(
              value: dailyAvg,
              type: QuickStatType.dailyAvg,
            ),
          ],
        );
      });
}
