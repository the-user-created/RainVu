import "dart:async";

import "package:collection/collection.dart";
import "package:rain_wise/backend/schema/index.dart";
import "package:rain_wise/backend/schema/util/firestore_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

class GaugesRecord extends FirestoreRecord {
  GaugesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "userID" field.
  String? _userID;

  String get userID => _userID ?? "";

  bool hasUserID() => _userID != null;

  // "gaugeName" field.
  String? _gaugeName;

  String get gaugeName => _gaugeName ?? "";

  bool hasGaugeName() => _gaugeName != null;

  // "location" field.
  LatLng? _location;

  LatLng? get location => _location;

  bool hasLocation() => _location != null;

  // "rainGaugeID" field.
  String? _rainGaugeID;

  String get rainGaugeID => _rainGaugeID ?? "";

  bool hasRainGaugeID() => _rainGaugeID != null;

  void _initializeFields() {
    _userID = snapshotData["userID"] as String?;
    _gaugeName = snapshotData["gaugeName"] as String?;
    _location = snapshotData["location"] as LatLng?;
    _rainGaugeID = snapshotData["rainGaugeID"] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection("gauges");

  static Stream<GaugesRecord> getDocument(final DocumentReference ref) =>
      ref.snapshots().map(GaugesRecord.fromSnapshot);

  static Future<GaugesRecord> getDocumentOnce(final DocumentReference ref) =>
      ref.get().then(GaugesRecord.fromSnapshot);

  static GaugesRecord fromSnapshot(final DocumentSnapshot snapshot) =>
      GaugesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data()! as Map<String, dynamic>),
      );

  static GaugesRecord getDocumentFromData(
    final Map<String, dynamic> data,
    final DocumentReference reference,
  ) =>
      GaugesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      "GaugesRecord(reference: ${reference.path}, data: $snapshotData)";

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(final Object other) =>
      other is GaugesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGaugesRecordData({
  final String? userID,
  final String? gaugeName,
  final LatLng? location,
  final String? rainGaugeID,
}) {
  final Map<String, dynamic> firestoreData = mapToFirestore(
    <String, dynamic>{
      "userID": userID,
      "gaugeName": gaugeName,
      "location": location,
      "rainGaugeID": rainGaugeID,
    }.withoutNulls,
  );

  return firestoreData;
}

class GaugesRecordDocumentEquality implements Equality<GaugesRecord> {
  const GaugesRecordDocumentEquality();

  @override
  bool equals(final GaugesRecord? e1, final GaugesRecord? e2) =>
      e1?.userID == e2?.userID &&
      e1?.gaugeName == e2?.gaugeName &&
      e1?.location == e2?.location &&
      e1?.rainGaugeID == e2?.rainGaugeID;

  @override
  int hash(final GaugesRecord? e) => const ListEquality()
      .hash([e?.userID, e?.gaugeName, e?.location, e?.rainGaugeID]);

  @override
  bool isValidKey(final Object? o) => o is GaugesRecord;
}
