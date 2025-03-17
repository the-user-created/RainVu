import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GaugesRecord extends FirestoreRecord {
  GaugesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "userID" field.
  String? _userID;

  String get userID => _userID ?? '';

  bool hasUserID() => _userID != null;

  // "gaugeName" field.
  String? _gaugeName;

  String get gaugeName => _gaugeName ?? '';

  bool hasGaugeName() => _gaugeName != null;

  // "location" field.
  LatLng? _location;

  LatLng? get location => _location;

  bool hasLocation() => _location != null;

  // "rainGaugeID" field.
  String? _rainGaugeID;

  String get rainGaugeID => _rainGaugeID ?? '';

  bool hasRainGaugeID() => _rainGaugeID != null;

  void _initializeFields() {
    _userID = snapshotData['userID'] as String?;
    _gaugeName = snapshotData['gaugeName'] as String?;
    _location = snapshotData['location'] as LatLng?;
    _rainGaugeID = snapshotData['rainGaugeID'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('gauges');

  static Stream<GaugesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GaugesRecord.fromSnapshot(s));

  static Future<GaugesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GaugesRecord.fromSnapshot(s));

  static GaugesRecord fromSnapshot(DocumentSnapshot snapshot) => GaugesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GaugesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GaugesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GaugesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GaugesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGaugesRecordData({
  String? userID,
  String? gaugeName,
  LatLng? location,
  String? rainGaugeID,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userID': userID,
      'gaugeName': gaugeName,
      'location': location,
      'rainGaugeID': rainGaugeID,
    }.withoutNulls,
  );

  return firestoreData;
}

class GaugesRecordDocumentEquality implements Equality<GaugesRecord> {
  const GaugesRecordDocumentEquality();

  @override
  bool equals(GaugesRecord? e1, GaugesRecord? e2) {
    return e1?.userID == e2?.userID &&
        e1?.gaugeName == e2?.gaugeName &&
        e1?.location == e2?.location &&
        e1?.rainGaugeID == e2?.rainGaugeID;
  }

  @override
  int hash(GaugesRecord? e) => const ListEquality()
      .hash([e?.userID, e?.gaugeName, e?.location, e?.rainGaugeID]);

  @override
  bool isValidKey(Object? o) => o is GaugesRecord;
}
