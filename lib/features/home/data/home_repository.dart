import "package:drift/drift.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/data/local/app_database.dart" hide RainGauge;
import "package:rain_wise/core/data/local/daos/rain_gauges_dao.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "home_repository.g.dart";

abstract class HomeRepository {
  Stream<HomeData> watchHomeData();

  Future<List<RainGauge>> getUserGauges();

  Future<void> saveRainfallEntry({
    required final String gaugeId,
    required final double amount,
    required final String unit,
    required final DateTime date,
  });
}

@Riverpod(keepAlive: true)
HomeRepository homeRepository(final HomeRepositoryRef ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftHomeRepository(db.rainfallEntriesDao, db.rainGaugesDao);
}

class DriftHomeRepository implements HomeRepository {
  DriftHomeRepository(this._entriesDao, this._gaugesDao);

  final RainfallEntriesDao _entriesDao;
  final RainGaugesDao _gaugesDao;

  // TODO: This is a simplified implementation. Should combine multiple streams.
  @override
  Stream<HomeData> watchHomeData() =>
      _entriesDao.watchRecentEntries(limit: 3).asyncMap((final recent) async {
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month);
        final DateTime weekStart =
            now.subtract(Duration(days: now.weekday - 1));

        // These would be optimized queries in a real app
        final List<RainfallEntry> allEntries =
            await _entriesDao.db.select(_entriesDao.rainfallEntries).get();

        final Iterable<RainfallEntry> monthEntries =
            allEntries.where((final e) => e.date.isAfter(monthStart));
        final double monthlyTotal = monthEntries.fold<double>(
          0,
          (final sum, final e) => sum + e.amount,
        );

        final Iterable<RainfallEntry> weekEntries =
            allEntries.where((final e) => e.date.isAfter(weekStart));
        final double weeklyTotal =
            weekEntries.fold<double>(0, (final sum, final e) => sum + e.amount);

        final double dailyAvg =
            monthEntries.isEmpty ? 0.0 : monthlyTotal / now.day;

        return HomeData(
          currentMonth: DateFormat.yMMMM().format(now),
          monthlyTotal: "${monthlyTotal.toStringAsFixed(1)} mm",
          recentEntries: recent
              .map(
                (final e) => RecentEntry(
                  dateLabel: DateFormat.yMd().add_jm().format(e.entry.date),
                  amount:
                      "${e.entry.amount.toStringAsFixed(1)} ${e.entry.unit}",
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

  @override
  Future<List<RainGauge>> getUserGauges() async {
    final gauges = await _gaugesDao.getAllGauges();
    return gauges.map((final g) => RainGauge(id: g.id, name: g.name)).toList();
  }

  @override
  Future<void> saveRainfallEntry({
    required final String gaugeId,
    required final double amount,
    required final String unit,
    required final DateTime date,
  }) async {
    final companion = RainfallEntriesCompanion.insert(
      gaugeId: Value(gaugeId),
      amount: amount,
      unit: unit,
      date: date,
    );
    await _entriesDao.insertEntry(companion);
  }
}
