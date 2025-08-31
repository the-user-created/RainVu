import "package:drift/drift.dart";
import "package:rain_wise/core/data/local/tables/rain_gauges.dart";
import "package:uuid/uuid.dart";

class RainfallEntries extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get gaugeId => text()
      .nullable()
      .references(RainGauges, #id, onDelete: KeyAction.setNull)();

  TextColumn get unit => text()();

  @override
  Set<Column> get primaryKey => {id};
}
