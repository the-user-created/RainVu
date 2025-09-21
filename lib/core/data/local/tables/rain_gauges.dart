import "package:drift/drift.dart";
import "package:uuid/uuid.dart";

class RainGauges extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v4())();

  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
