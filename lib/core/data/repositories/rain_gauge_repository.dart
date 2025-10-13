import "package:drift/drift.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rain_gauges_dao.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart" as domain;
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "rain_gauge_repository.g.dart";

abstract class RainGaugeRepository {
  Stream<List<domain.RainGauge>> watchGauges();

  Future<List<domain.RainGauge>> fetchGauges();

  Future<domain.RainGauge?> getGaugeById(final String gaugeId);

  Future<domain.RainGauge> addGauge({required final String name});

  Future<void> updateGauge(final domain.RainGauge updatedGauge);

  Future<void> deleteGauge(final String gaugeId);

  Future<void> deleteGaugeAndEntries(final String gaugeId);
}

@Riverpod(keepAlive: true)
RainGaugeRepository rainGaugeRepository(final Ref ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftRainGaugeRepository(db, db.rainGaugesDao, db.rainfallEntriesDao);
}

class DriftRainGaugeRepository implements RainGaugeRepository {
  DriftRainGaugeRepository(this._db, this._dao, this._rainfallEntriesDao);

  final AppDatabase _db;
  final RainGaugesDao _dao;
  final RainfallEntriesDao _rainfallEntriesDao;

  @override
  Stream<List<domain.RainGauge>> watchGauges() => _dao
      .watchAllGaugesWithEntryCount()
      .map((final gauges) => gauges.map(_mapDriftWithCountToDomain).toList())
      .handleError((final e, final s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "Failed to watch rain gauges",
        );
      });

  @override
  Future<List<domain.RainGauge>> fetchGauges() async {
    try {
      final List<RainGaugeWithEntryCount> gauges = await _dao
          .getAllGaugesWithEntryCount();
      return gauges.map(_mapDriftWithCountToDomain).toList();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to fetch rain gauges",
      );
      rethrow;
    }
  }

  @override
  Future<domain.RainGauge?> getGaugeById(final String gaugeId) async {
    try {
      final RainGauge? gauge = await _dao.getGaugeById(gaugeId);
      return gauge == null ? null : _mapDriftToDomain(gauge);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to get gauge by ID",
      );
      rethrow;
    }
  }

  @override
  Future<domain.RainGauge> addGauge({required final String name}) async {
    try {
      final newGauge = domain.RainGauge(id: const Uuid().v4(), name: name);
      final RainGaugesCompanion companion = _mapDomainToCompanion(newGauge);
      await _dao.insertGauge(companion);
      return newGauge;
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to add rain gauge",
      );
      rethrow;
    }
  }

  @override
  Future<void> updateGauge(final domain.RainGauge updatedGauge) async {
    try {
      await _dao.updateGauge(_mapDomainToCompanion(updatedGauge));
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to update rain gauge",
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteGauge(final String gaugeId) async {
    try {
      await _db.transaction(() async {
        await _rainfallEntriesDao.reassignEntries(
          gaugeId,
          AppConstants.defaultGaugeId,
        );
        await _dao.deleteGauge(RainGaugesCompanion(id: Value(gaugeId)));
      });
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to delete gauge and reassign entries",
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteGaugeAndEntries(final String gaugeId) async {
    try {
      await _db.transaction(() async {
        await _rainfallEntriesDao.deleteEntriesForGauge(gaugeId);
        await _dao.deleteGauge(RainGaugesCompanion(id: Value(gaugeId)));
      });
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to delete gauge and its entries",
      );
      rethrow;
    }
  }

  domain.RainGauge _mapDriftToDomain(final RainGauge driftGauge) =>
      domain.RainGauge(id: driftGauge.id, name: driftGauge.name);

  domain.RainGauge _mapDriftWithCountToDomain(
    final RainGaugeWithEntryCount driftGauge,
  ) => domain.RainGauge(
    id: driftGauge.gauge.id,
    name: driftGauge.gauge.name,
    entryCount: driftGauge.entryCount,
  );

  RainGaugesCompanion _mapDomainToCompanion(
    final domain.RainGauge domainGauge,
  ) => RainGaugesCompanion(
    id: Value(domainGauge.id),
    name: Value(domainGauge.name),
  );
}
