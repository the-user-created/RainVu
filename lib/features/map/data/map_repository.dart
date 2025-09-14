import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/map/domain/rainfall_map_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "map_repository.g.dart";

abstract class MapRepository {
  Stream<List<RainfallMapEntry>> watchRecentEntries({final int limit = 5});
}

@riverpod
MapRepository mapRepository(final Ref ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftMapRepository(db.rainfallEntriesDao);
}

class DriftMapRepository implements MapRepository {
  DriftMapRepository(this._dao);

  final RainfallEntriesDao _dao;

  // Map the DAO result to the feature-specific domain model.
  // Filter out entries that don't have a gauge with location data,
  // as they cannot be displayed on the map.
  @override
  Stream<List<RainfallMapEntry>> watchRecentEntries({final int limit = 5}) =>
      _dao.watchRecentEntries(limit: limit).map(
            (final entriesWithGauges) => entriesWithGauges
                .where(
                  (final e) =>
                      e.gauge != null &&
                      e.gauge!.latitude != null &&
                      e.gauge!.longitude != null,
                )
                .map(_mapToDomain)
                .toList(),
          );

  /// Converts a [RainfallEntryWithGauge] from the DAO into a [RainfallMapEntry]
  /// for the map feature.
  RainfallMapEntry _mapToDomain(final RainfallEntryWithGauge driftEntry) {
    final RainfallEntry entry = driftEntry.entry;
    final RainGauge gauge =
        driftEntry.gauge!; // We've already filtered out nulls.

    return RainfallMapEntry(
      id: entry.id,
      dateTime: entry.date,
      locationName: gauge.name,
      coordinates:
          "${gauge.latitude!.toStringAsFixed(4)}, ${gauge.longitude!.toStringAsFixed(4)}",
      amount: entry.amount,
      unit: entry.unit,
    );
  }
}
