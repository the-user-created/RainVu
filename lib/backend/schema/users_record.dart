import "dart:async";

import "package:collection/collection.dart";
import "package:rain_wise/backend/schema/index.dart";
import "package:rain_wise/backend/schema/util/firestore_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "email" field.
  String? _email;

  String get email => _email ?? "";

  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;

  String get displayName => _displayName ?? "";

  bool hasDisplayName() => _displayName != null;

  // "uid" field.
  String? _uid;

  String get uid => _uid ?? "";

  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;

  DateTime? get createdTime => _createdTime;

  bool hasCreatedTime() => _createdTime != null;

  // "photo_url" field.
  String? _photoUrl;

  String get photoUrl => _photoUrl ?? "";

  bool hasPhotoUrl() => _photoUrl != null;

  // "phone_number" field.
  String? _phoneNumber;

  String get phoneNumber => _phoneNumber ?? "";

  bool hasPhoneNumber() => _phoneNumber != null;

  void _initializeFields() {
    _email = snapshotData["email"] as String?;
    _displayName = snapshotData["display_name"] as String?;
    _uid = snapshotData["uid"] as String?;
    _createdTime = snapshotData["created_time"] as DateTime?;
    _photoUrl = snapshotData["photo_url"] as String?;
    _phoneNumber = snapshotData["phone_number"] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection("users");

  static Stream<UsersRecord> getDocument(final DocumentReference ref) =>
      ref.snapshots().map(UsersRecord.fromSnapshot);

  static Future<UsersRecord> getDocumentOnce(final DocumentReference ref) =>
      ref.get().then(UsersRecord.fromSnapshot);

  static UsersRecord fromSnapshot(final DocumentSnapshot snapshot) =>
      UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data()! as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    final Map<String, dynamic> data,
    final DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      "UsersRecord(reference: ${reference.path}, data: $snapshotData)";

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(final Object other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  final String? email,
  final String? displayName,
  final String? uid,
  final DateTime? createdTime,
  final String? photoUrl,
  final String? phoneNumber,
}) {
  final Map<String, dynamic> firestoreData = mapToFirestore(
    <String, dynamic>{
      "email": email,
      "display_name": displayName,
      "uid": uid,
      "created_time": createdTime,
      "photo_url": photoUrl,
      "phone_number": phoneNumber,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(final UsersRecord? e1, final UsersRecord? e2) =>
      e1?.email == e2?.email &&
      e1?.displayName == e2?.displayName &&
      e1?.uid == e2?.uid &&
      e1?.createdTime == e2?.createdTime &&
      e1?.photoUrl == e2?.photoUrl &&
      e1?.phoneNumber == e2?.phoneNumber;

  @override
  int hash(final UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.uid,
        e?.createdTime,
        e?.photoUrl,
        e?.phoneNumber
      ]);

  @override
  bool isValidKey(final Object? o) => o is UsersRecord;
}
