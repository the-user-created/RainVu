import "package:drift/drift.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart" as domain_gauge;
import "package:rain_wise/features/rainfall_entry/domain/rainfall_entry.dart"
    as domain;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "rainfall_entry_repository.g.dart";

abstract class RainfallEntryRepository {
  Future<List<domain.RainfallEntry>> fetchEntriesForMonth(final DateTime month);

  Future<void> addEntry(final domain.RainfallEntry entry);

  Future<void> updateEntry(final domain.RainfallEntry entry);

  Future<void> deleteEntry(final String entryId);
}

@Riverpod(keepAlive: true)
RainfallEntryRepository rainfallEntryRepository(
  final RainfallEntryRepositoryRef ref,
) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftRainfallEntryRepository(db.rainfallEntriesDao);
}

class DriftRainfallEntryRepository implements RainfallEntryRepository {
  DriftRainfallEntryRepository(this._dao);

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
  Future<void> addEntry(final domain.RainfallEntry entry) =>
      _dao.insertEntry(_mapDomainToCompanion(entry));

  @override
  Future<void> updateEntry(final domain.RainfallEntry entry) =>
      _dao.updateEntry(_mapDomainToCompanion(entry));

  @override
  Future<void> deleteEntry(final String entryId) =>
      _dao.deleteEntry(RainfallEntriesCompanion(id: Value(entryId)));

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
