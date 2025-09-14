import "package:drift/drift.dart";
import "package:rain_wise/core/data/local/connection/mobile.dart";
import "package:rain_wise/core/data/local/daos/rain_gauges_dao.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/core/data/local/tables/rain_gauges.dart";
import "package:rain_wise/core/data/local/tables/rainfall_entries.dart";
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
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(final Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
