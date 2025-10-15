import "package:drift/drift.dart";
import "package:rainvu/app_constants.dart";
import "package:rainvu/core/data/local/connection/mobile.dart";
import "package:rainvu/core/data/local/daos/rain_gauges_dao.dart";
import "package:rainvu/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rainvu/core/data/local/tables/rain_gauges.dart";
import "package:rainvu/core/data/local/tables/rainfall_entries.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "app_database.g.dart";

@DriftDatabase(
  tables: [RainGauges, RainfallEntries],
  daos: [RainGaugesDao, RainfallEntriesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (final m) async {
      await m.createAll();

      // Create the default rain gauge
      await into(rainGauges).insert(
        const RainGaugesCompanion(
          id: Value(AppConstants.defaultGaugeId),
          name: Value(AppConstants.defaultGaugeName),
        ),
      );
    },
  );

  Future<void> deleteAllData() => transaction(() async {
    for (final TableInfo<Table, Object?> table in allTables) {
      await delete(table).go();
    }
  });
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(final Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
