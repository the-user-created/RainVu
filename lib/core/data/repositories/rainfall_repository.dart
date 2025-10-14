import "package:drift/drift.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:rainly/core/data/local/app_database.dart";
import "package:rainly/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rainly/shared/domain/rain_gauge.dart" as domain_gauge;
import "package:rainly/shared/domain/rainfall_entry.dart" as domain;
import "package:riverpod_annotation/riverpod_annotation.dart";

export "package:rainly/core/data/local/daos/rainfall_entries_dao.dart"
    show DateRangeResult;

part "rainfall_repository.g.dart";

abstract class RainfallRepository {
  Stream<List<domain.RainfallEntry>> watchEntriesForMonth(
    final DateTime month, {
    final String? gaugeId,
  });

  Stream<List<domain.RainfallEntry>> watchRecentEntries({final int limit = 5});

  Future<List<domain.RainfallEntry>> fetchRecentEntries({final int limit = 3});

  Future<void> addEntry(final domain.RainfallEntry entry);

  Future<void> updateEntry(final domain.RainfallEntry entry);

  Future<void> deleteEntry(final String entryId);

  Future<double> getTotalAmountBetween(
    final DateTime start,
    final DateTime end,
  );

  Stream<void> watchTableUpdates();

  Future<List<MonthlyTotal>> getMonthlyTotals({
    required final DateTime start,
    required final DateTime end,
  });

  Future<double> getTotalRainfall();

  Future<List<int>> getAvailableYears();

  Future<int> countEntriesForGauge(final String gaugeId);

  Future<DateRangeResult> getDateRangeOfEntries();
}

@Riverpod(keepAlive: true)
RainfallRepository rainfallRepository(final Ref ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftRainfallRepository(db.rainfallEntriesDao);
}

class DriftRainfallRepository implements RainfallRepository {
  DriftRainfallRepository(this._dao);

  final RainfallEntriesDao _dao;

  @override
  Stream<List<domain.RainfallEntry>> watchEntriesForMonth(
    final DateTime month, {
    final String? gaugeId,
  }) => _dao
      .watchEntriesForMonth(month, gaugeId: gaugeId)
      .map((final e) => e.map(_mapDriftToDomain).toList())
      .handleError((final e, final s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "Failed to watch rainfall entries for month",
        );
      });

  @override
  Stream<List<domain.RainfallEntry>> watchRecentEntries({
    final int limit = 5,
  }) => _dao
      .watchRecentEntries(limit: limit)
      .map((final e) => e.map(_mapDriftToDomain).toList())
      .handleError((final e, final s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "Failed to watch recent rainfall entries",
        );
      });

  @override
  Future<List<domain.RainfallEntry>> fetchRecentEntries({
    final int limit = 3,
  }) async {
    try {
      final List<RainfallEntryWithGauge> entries = await _dao.getRecentEntries(
        limit: limit,
      );
      return entries.map(_mapDriftToDomain).toList();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to fetch recent rainfall entries",
      );
      rethrow;
    }
  }

  @override
  Future<void> addEntry(final domain.RainfallEntry entry) async {
    try {
      await _dao.insertEntry(_mapDomainToCompanion(entry));
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to add rainfall entry",
      );
      rethrow;
    }
  }

  @override
  Future<void> updateEntry(final domain.RainfallEntry entry) async {
    try {
      await _dao.updateEntry(_mapDomainToCompanion(entry));
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to update rainfall entry",
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteEntry(final String entryId) async {
    try {
      await _dao.deleteEntry(RainfallEntriesCompanion(id: Value(entryId)));
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to delete rainfall entry",
      );
      rethrow;
    }
  }

  @override
  Future<double> getTotalAmountBetween(
    final DateTime start,
    final DateTime end,
  ) async {
    try {
      return await _dao.getTotalAmountBetween(start, end);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to get total rainfall amount between dates",
      );
      rethrow;
    }
  }

  @override
  Stream<void> watchTableUpdates() =>
      _dao.watchTableUpdates().handleError((final e, final s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "Failed to watch rainfall table updates",
        );
      });

  @override
  Future<List<MonthlyTotal>> getMonthlyTotals({
    required final DateTime start,
    required final DateTime end,
  }) async {
    try {
      return await _dao.getMonthlyTotals(start: start, end: end);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to get monthly totals",
      );
      rethrow;
    }
  }

  @override
  Future<double> getTotalRainfall() async {
    try {
      return await _dao.getTotalRainfall();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to get total rainfall",
      );
      rethrow;
    }
  }

  @override
  Future<List<int>> getAvailableYears() async {
    try {
      return await _dao.getAvailableYears();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to get available years",
      );
      rethrow;
    }
  }

  @override
  Future<int> countEntriesForGauge(final String gaugeId) async {
    try {
      return await _dao.countEntriesForGauge(gaugeId);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to count entries for gauge",
      );
      rethrow;
    }
  }

  @override
  Future<DateRangeResult> getDateRangeOfEntries() async {
    try {
      return await _dao.getDateRangeOfEntries();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to get date range of entries",
      );
      rethrow;
    }
  }

  domain.RainfallEntry _mapDriftToDomain(
    final RainfallEntryWithGauge driftEntry,
  ) {
    final domain_gauge.RainGauge? domainGauge = driftEntry.gauge == null
        ? null
        : domain_gauge.RainGauge(
            id: driftEntry.gauge!.id,
            name: driftEntry.gauge!.name,
          );

    return domain.RainfallEntry(
      id: driftEntry.entry.id,
      amount: driftEntry.entry.amount,
      date: driftEntry.entry.date,
      gaugeId: driftEntry.entry.gaugeId ?? "",
      unit: driftEntry.entry.unit,
      gauge: domainGauge,
    );
  }

  RainfallEntriesCompanion _mapDomainToCompanion(
    final domain.RainfallEntry entry,
  ) => RainfallEntriesCompanion(
    id: entry.id == null ? const Value.absent() : Value(entry.id!),
    amount: Value(entry.amount),
    date: Value(entry.date),
    gaugeId: Value(entry.gaugeId),
    unit: Value(entry.unit),
  );
}
