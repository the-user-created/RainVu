// ignore_for_file: prefer_const_constructors

import "package:drift/drift.dart";
import "package:rainly/core/data/local/tables/rain_gauges.dart";
import "package:uuid/uuid.dart";

class RainfallEntries extends Table {
  TextColumn get id => text().clientDefault(() => Uuid().v4())();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get gaugeId => text().nullable().references(
    RainGauges,
    #id,
    onDelete: KeyAction.setNull,
  )();

  TextColumn get unit => text()();

  @override
  Set<Column> get primaryKey => {id};
}
