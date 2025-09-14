import "package:drift/drift.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart" as domain_gauge;
import "package:rain_wise/shared/domain/rainfall_entry.dart" as domain;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "rainfall_repository.g.dart";

abstract class RainfallRepository {
  Future<List<domain.RainfallEntry>> fetchEntriesForMonth(final DateTime month);

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
}

@Riverpod(keepAlive: true)
RainfallRepository rainfallRepository(
  final Ref ref,
) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftRainfallRepository(db.rainfallEntriesDao);
}

class DriftRainfallRepository implements RainfallRepository {
  DriftRainfallRepository(this._dao);

  final RainfallEntriesDao _dao;

  @override
  Future<List<domain.RainfallEntry>> fetchEntriesForMonth(
    final DateTime month,
  ) async {
    final List<RainfallEntryWithGauge> entries =
        await _dao.getEntriesForMonth(month);
    return entries.map(_mapDriftToDomain).toList();
  }

  @override
  Stream<List<domain.RainfallEntry>> watchRecentEntries({
    final int limit = 5,
  }) =>
      _dao
          .watchRecentEntries(limit: limit)
          .map((final e) => e.map(_mapDriftToDomain).toList());

  @override
  Future<List<domain.RainfallEntry>> fetchRecentEntries({
    final int limit = 3,
  }) async {
    final List<RainfallEntryWithGauge> entries =
        await _dao.getRecentEntries(limit: limit);
    return entries.map(_mapDriftToDomain).toList();
  }

  @override
  Future<void> addEntry(final domain.RainfallEntry entry) =>
      _dao.insertEntry(_mapDomainToCompanion(entry));

  @override
  Future<void> updateEntry(final domain.RainfallEntry entry) =>
      _dao.updateEntry(_mapDomainToCompanion(entry));

  @override
  Future<void> deleteEntry(final String entryId) =>
      _dao.deleteEntry(RainfallEntriesCompanion(id: Value(entryId)));

  @override
  Future<double> getTotalAmountBetween(
    final DateTime start,
    final DateTime end,
  ) =>
      _dao.getTotalAmountBetween(start, end);

  @override
  Stream<void> watchTableUpdates() => _dao.watchTableUpdates();

  domain.RainfallEntry _mapDriftToDomain(
    final RainfallEntryWithGauge driftEntry,
  ) {
    final domain_gauge.RainGauge? domainGauge = driftEntry.gauge == null
        ? null
        : domain_gauge.RainGauge(
            id: driftEntry.gauge!.id,
            name: driftEntry.gauge!.name,
            latitude: driftEntry.gauge!.latitude,
            longitude: driftEntry.gauge!.longitude,
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
  ) =>
      RainfallEntriesCompanion(
        id: entry.id == null ? const Value.absent() : Value(entry.id!),
        amount: Value(entry.amount),
        date: Value(entry.date),
        gaugeId: Value(entry.gaugeId),
        unit: Value(entry.unit),
      );
}
