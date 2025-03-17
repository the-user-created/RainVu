import "dart:async";

import "package:collection/collection.dart";
import "package:rain_wise/backend/schema/firestore_util.dart";
import "package:rain_wise/backend/schema/index.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

class NotificationsRecord extends FirestoreRecord {
  factory NotificationsRecord.fromSnapshot(final DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data()! as Map<String, dynamic>),
      );

  factory NotificationsRecord.fromData(
    final Map<String, dynamic> data,
    final DocumentReference reference,
  ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  NotificationsRecord._(
    super.reference,
    super.snapshotData,
  ) {
    _initializeFields();
  }

  // "daily" field.
  bool? _daily;

  bool get daily => _daily ?? false;

  bool hasDaily() => _daily != null;

  // "dailyTime" field.
  DateTime? _dailyTime;

  DateTime? get dailyTime => _dailyTime;

  bool hasDailyTime() => _dailyTime != null;

  // "weeklySummary" field.
  bool? _weeklySummary;

  bool get weeklySummary => _weeklySummary ?? false;

  bool hasWeeklySummary() => _weeklySummary != null;

  // "severeWeather" field.
  bool? _severeWeather;

  bool get severeWeather => _severeWeather ?? false;

  bool hasSevereWeather() => _severeWeather != null;

  // "appUpdates" field.
  bool? _appUpdates;

  bool get appUpdates => _appUpdates ?? false;

  bool hasAppUpdates() => _appUpdates != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _daily = snapshotData["daily"] as bool?;
    _dailyTime = snapshotData["dailyTime"] as DateTime?;
    _weeklySummary = snapshotData["weeklySummary"] as bool?;
    _severeWeather = snapshotData["severeWeather"] as bool?;
    _appUpdates = snapshotData["appUpdates"] as bool?;
  }

  static Query<Map<String, dynamic>> collection(
          [final DocumentReference? parent]) =>
      parent != null
          ? parent.collection("notifications")
          : FirebaseFirestore.instance.collectionGroup("notifications");

  static DocumentReference createDoc(final DocumentReference parent,
          {final String? id}) =>
      parent.collection("notifications").doc(id);

  static Stream<NotificationsRecord> getDocument(final DocumentReference ref) =>
      ref.snapshots().map(NotificationsRecord.fromSnapshot);

  static Future<NotificationsRecord> getDocumentOnce(
          final DocumentReference ref) =>
      ref.get().then(NotificationsRecord.fromSnapshot);

  @override
  String toString() =>
      "NotificationsRecord(reference: ${reference.path}, data: $snapshotData)";

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(final Object other) =>
      other is NotificationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  final bool? daily,
  final DateTime? dailyTime,
  final bool? weeklySummary,
  final bool? severeWeather,
  final bool? appUpdates,
}) {
  final Map<String, dynamic> firestoreData = mapToFirestore(
    <String, dynamic>{
      "daily": daily,
      "dailyTime": dailyTime,
      "weeklySummary": weeklySummary,
      "severeWeather": severeWeather,
      "appUpdates": appUpdates,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(final NotificationsRecord? e1, final NotificationsRecord? e2) =>
      e1?.daily == e2?.daily &&
      e1?.dailyTime == e2?.dailyTime &&
      e1?.weeklySummary == e2?.weeklySummary &&
      e1?.severeWeather == e2?.severeWeather &&
      e1?.appUpdates == e2?.appUpdates;

  @override
  int hash(final NotificationsRecord? e) => const ListEquality().hash([
        e?.daily,
        e?.dailyTime,
        e?.weeklySummary,
        e?.severeWeather,
        e?.appUpdates
      ]);

  @override
  bool isValidKey(final Object? o) => o is NotificationsRecord;
}
