import "package:intl/intl.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "home_repository.g.dart";

abstract class HomeRepository {
  Stream<HomeData> watchHomeData();
}

@Riverpod(keepAlive: true)
HomeRepository homeRepository(final HomeRepositoryRef ref) {
  final RainfallRepository rainfallRepo = ref.watch(rainfallRepositoryProvider);
  return DriftHomeRepository(rainfallRepo);
}

class DriftHomeRepository implements HomeRepository {
  DriftHomeRepository(this._rainfallRepo);

  final RainfallRepository _rainfallRepo;

  // This stream is triggered by new recent entries.
  // It then fetches current stats to build the complete HomeData object.
  @override
  Stream<HomeData> watchHomeData() =>
      _rainfallRepo.watchRecentEntries(limit: 3).asyncMap((final recent) async {
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month);
        final DateTime weekStart =
            now.subtract(Duration(days: now.weekday - 1));

        final double monthlyTotal =
            await _rainfallRepo.getTotalAmountBetween(monthStart, now);
        final double weeklyTotal =
            await _rainfallRepo.getTotalAmountBetween(weekStart, now);

        final double dailyAvg = (now.day == 0) ? 0.0 : monthlyTotal / now.day;

        return HomeData(
          currentMonth: DateFormat.yMMMM().format(now),
          monthlyTotal: "${monthlyTotal.toStringAsFixed(1)} mm",
          recentEntries: recent
              .map(
                (final e) => RecentEntry(
                  dateLabel: DateFormat.yMd().add_jm().format(e.date),
                  amount: "${e.amount.toStringAsFixed(1)} ${e.unit}",
                ),
              )
              .toList(),
          quickStats: [
            QuickStat(
              value: weeklyTotal.toStringAsFixed(1),
              label: "mm this week",
            ),
            QuickStat(
              value: monthlyTotal.toStringAsFixed(1),
              label: "mm this month",
            ),
            QuickStat(
              value: dailyAvg.toStringAsFixed(1),
              label: "mm daily avg",
            ),
          ],
        );
      });
}
