import "package:drift/drift.dart";
import "package:uuid/uuid.dart";

class RainGauges extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get name => text()();

  RealColumn get latitude => real().nullable()();

  RealColumn get longitude => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
