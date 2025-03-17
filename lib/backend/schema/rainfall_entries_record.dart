import "dart:async";

import "package:collection/collection.dart";
import "package:rain_wise/backend/schema/firestore_util.dart";
import "package:rain_wise/backend/schema/index.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

class RainfallEntriesRecord extends FirestoreRecord {
  factory RainfallEntriesRecord.fromSnapshot(final DocumentSnapshot snapshot) =>
      RainfallEntriesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data()! as Map<String, dynamic>),
      );

  factory RainfallEntriesRecord.fromData(
    final Map<String, dynamic> data,
    final DocumentReference reference,
  ) =>
      RainfallEntriesRecord._(reference, mapFromFirestore(data));

  RainfallEntriesRecord._(
    super.reference,
    super.snapshotData,
  ) {
    _initializeFields();
  }

  // "entryId" field.
  String? _entryId;

  String get entryId => _entryId ?? "";

  bool hasEntryId() => _entryId != null;

  // "userId" field.
  String? _userId;

  String get userId => _userId ?? "";

  bool hasUserId() => _userId != null;

  // "date" field.
  DateTime? _date;

  DateTime? get date => _date;

  bool hasDate() => _date != null;

  // "rainfallAmount" field.
  double? _rainfallAmount;

  double get rainfallAmount => _rainfallAmount ?? 0.0;

  bool hasRainfallAmount() => _rainfallAmount != null;

  // "notes" field.
  String? _notes;

  String get notes => _notes ?? "";

  bool hasNotes() => _notes != null;

  // "createdAt" field.
  DateTime? _createdAt;

  DateTime? get createdAt => _createdAt;

  bool hasCreatedAt() => _createdAt != null;

  // "rainGaugeID" field.
  String? _rainGaugeID;

  String get rainGaugeID => _rainGaugeID ?? "";

  bool hasRainGaugeID() => _rainGaugeID != null;

  void _initializeFields() {
    _entryId = snapshotData["entryId"] as String?;
    _userId = snapshotData["userId"] as String?;
    _date = snapshotData["date"] as DateTime?;
    _rainfallAmount = castToType<double>(snapshotData["rainfallAmount"]);
    _notes = snapshotData["notes"] as String?;
    _createdAt = snapshotData["createdAt"] as DateTime?;
    _rainGaugeID = snapshotData["rainGaugeID"] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection("rainfall_entries");

  static Stream<RainfallEntriesRecord> getDocument(
          final DocumentReference ref) =>
      ref.snapshots().map(RainfallEntriesRecord.fromSnapshot);

  static Future<RainfallEntriesRecord> getDocumentOnce(
          final DocumentReference ref) =>
      ref.get().then(RainfallEntriesRecord.fromSnapshot);

  @override
  String toString() =>
      "RainfallEntriesRecord(reference: ${reference.path}, data: $snapshotData)";

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(final Object other) =>
      other is RainfallEntriesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRainfallEntriesRecordData({
  final String? entryId,
  final String? userId,
  final DateTime? date,
  final double? rainfallAmount,
  final String? notes,
  final DateTime? createdAt,
  final String? rainGaugeID,
}) {
  final Map<String, dynamic> firestoreData = mapToFirestore(
    <String, dynamic>{
      "entryId": entryId,
      "userId": userId,
      "date": date,
      "rainfallAmount": rainfallAmount,
      "notes": notes,
      "createdAt": createdAt,
      "rainGaugeID": rainGaugeID,
    }.withoutNulls,
  );

  return firestoreData;
}

class RainfallEntriesRecordDocumentEquality
    implements Equality<RainfallEntriesRecord> {
  const RainfallEntriesRecordDocumentEquality();

  @override
  bool equals(
          final RainfallEntriesRecord? e1, final RainfallEntriesRecord? e2) =>
      e1?.entryId == e2?.entryId &&
      e1?.userId == e2?.userId &&
      e1?.date == e2?.date &&
      e1?.rainfallAmount == e2?.rainfallAmount &&
      e1?.notes == e2?.notes &&
      e1?.createdAt == e2?.createdAt &&
      e1?.rainGaugeID == e2?.rainGaugeID;

  @override
  int hash(final RainfallEntriesRecord? e) => const ListEquality().hash([
        e?.entryId,
        e?.userId,
        e?.date,
        e?.rainfallAmount,
        e?.notes,
        e?.createdAt,
        e?.rainGaugeID
      ]);

  @override
  bool isValidKey(final Object? o) => o is RainfallEntriesRecord;
}
