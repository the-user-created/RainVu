import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:rain_wise/auth/firebase_auth/auth_util.dart";
import "package:rain_wise/backend/schema/gauges_record.dart";
import "package:rain_wise/backend/schema/notifications_record.dart";
import "package:rain_wise/backend/schema/rainfall_entries_record.dart";
import "package:rain_wise/backend/schema/users_record.dart";
import "package:rain_wise/backend/schema/util/firestore_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

export "dart:async" show StreamSubscription;

export "package:cloud_firestore/cloud_firestore.dart" hide Order;
export "package:firebase_core/firebase_core.dart";

export "schema/gauges_record.dart";
export "schema/index.dart";
export "schema/notifications_record.dart";
export "schema/rainfall_entries_record.dart";
export "schema/users_record.dart";
export "schema/util/firestore_util.dart";
export "schema/util/schema_util.dart";

/// Functions to query UsersRecords (as a Stream and as a Future).
Future<int> queryUsersRecordCount({
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
}) =>
    queryCollectionCount(
      UsersRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<UsersRecord>> queryUsersRecord({
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) =>
    queryCollection(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<UsersRecord>> queryUsersRecordOnce({
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) =>
    queryCollectionOnce(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query RainfallEntriesRecords (as a Stream and as a Future).
Future<int> queryRainfallEntriesRecordCount({
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
}) =>
    queryCollectionCount(
      RainfallEntriesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<RainfallEntriesRecord>> queryRainfallEntriesRecord({
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) =>
    queryCollection(
      RainfallEntriesRecord.collection,
      RainfallEntriesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<RainfallEntriesRecord>> queryRainfallEntriesRecordOnce({
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) =>
    queryCollectionOnce(
      RainfallEntriesRecord.collection,
      RainfallEntriesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query GaugesRecords (as a Stream and as a Future).
Future<int> queryGaugesRecordCount({
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
}) =>
    queryCollectionCount(
      GaugesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<GaugesRecord>> queryGaugesRecord({
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) =>
    queryCollection(
      GaugesRecord.collection,
      GaugesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<GaugesRecord>> queryGaugesRecordOnce({
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) =>
    queryCollectionOnce(
      GaugesRecord.collection,
      GaugesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query NotificationsRecords (as a Stream and as a Future).
Future<int> queryNotificationsRecordCount({
  final DocumentReference? parent,
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
}) =>
    queryCollectionCount(
      NotificationsRecord.collection(parent),
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<NotificationsRecord>> queryNotificationsRecord({
  final DocumentReference? parent,
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) =>
    queryCollection(
      NotificationsRecord.collection(parent),
      NotificationsRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<NotificationsRecord>> queryNotificationsRecordOnce({
  final DocumentReference? parent,
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) =>
    queryCollectionOnce(
      NotificationsRecord.collection(parent),
      NotificationsRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<int> queryCollectionCount(
  final Query collection, {
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
}) {
  final Query<Object?> Function(Query<Object?> p1) builder =
      queryBuilder ?? (final q) => q;
  Query<Object?> query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  return query.count().get().catchError((final err) {
    debugPrint("Error querying $collection: $err");
  }).then((final value) => value.count!);
}

Stream<List<T>> queryCollection<T>(
  final Query collection,
  final RecordBuilder<T> recordBuilder, {
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) {
  final Query<Object?> Function(Query<Object?> p1) builder =
      queryBuilder ?? (final q) => q;
  Query<Object?> query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().handleError((final err) {
    debugPrint("Error querying $collection: $err");
  }).map((final s) => s.docs
      .map(
        (final d) => safeGet(
          () => recordBuilder(d),
          (final e) =>
              debugPrint("Error serializing doc ${d.reference.path}:\n$e"),
        ),
      )
      .where((final d) => d != null)
      .map((final d) => d!)
      .toList());
}

Future<List<T>> queryCollectionOnce<T>(
  final Query collection,
  final RecordBuilder<T> recordBuilder, {
  final Query Function(Query)? queryBuilder,
  final int limit = -1,
  final bool singleRecord = false,
}) {
  final Query<Object?> Function(Query<Object?> p1) builder =
      queryBuilder ?? (final q) => q;
  Query<Object?> query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.get().then((final s) => s.docs
      .map(
        (final d) => safeGet(
          () => recordBuilder(d),
          (final e) =>
              debugPrint("Error serializing doc ${d.reference.path}:\n$e"),
        ),
      )
      .where((final d) => d != null)
      .map((final d) => d!)
      .toList());
}

Filter filterIn(final String field, final List? list) =>
    (list?.isEmpty ?? true) ? Filter(field) : Filter(field, whereIn: list);

Filter filterArrayContainsAny(final String field, final List? list) =>
    (list?.isEmpty ?? true)
        ? Filter(field)
        : Filter(field, arrayContainsAny: list);

extension QueryExtension on Query {
  Query whereIn(final String field, final List? list) => (list?.isEmpty ?? true)
      ? where(field, whereIn: null)
      : where(field, whereIn: list);

  Query whereNotIn(final String field, final List? list) =>
      (list?.isEmpty ?? true)
          ? where(field, whereNotIn: null)
          : where(field, whereNotIn: list);

  Query whereArrayContainsAny(final String field, final List? list) =>
      (list?.isEmpty ?? true)
          ? where(field, arrayContainsAny: null)
          : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);

  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(
  final Query collection,
  final RecordBuilder<T> recordBuilder, {
  required final int pageSize,
  required final bool isStream,
  final Query Function(Query)? queryBuilder,
  final DocumentSnapshot? nextPageMarker,
}) async {
  final Query<Object?> Function(Query<Object?> p1) builder =
      queryBuilder ?? (final q) => q;
  Query<Object?> query = builder(collection).limit(pageSize);
  if (nextPageMarker != null) {
    query = query.startAfterDocument(nextPageMarker);
  }
  Stream<QuerySnapshot>? docSnapshotStream;
  QuerySnapshot docSnapshot;
  if (isStream) {
    docSnapshotStream = query.snapshots();
    docSnapshot = await docSnapshotStream.first;
  } else {
    docSnapshot = await query.get();
  }
  List<T> getDocs(final QuerySnapshot s) => s.docs
      .map(
        (final d) => safeGet(
          () => recordBuilder(d),
          (final e) =>
              debugPrint("Error serializing doc ${d.reference.path}:\n$e"),
        ),
      )
      .where((final d) => d != null)
      .map((final d) => d!)
      .toList();
  final List<T> data = getDocs(docSnapshot);
  final Stream<List<T>>? dataStream = docSnapshotStream?.map(getDocs);
  final QueryDocumentSnapshot<Object?>? nextPageToken =
      docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
  return FFFirestorePage(data, dataStream, nextPageToken);
}

// Creates a Firestore document representing the logged in user if it doesn't yet exist
Future maybeCreateUser(final User user) async {
  final DocumentReference<Object?> userRecord =
      UsersRecord.collection.doc(user.uid);
  final bool userExists = await userRecord.get().then((final u) => u.exists);
  if (userExists) {
    currentUserDocument = await UsersRecord.getDocumentOnce(userRecord);
    return;
  }

  final Map<String, dynamic> userData = createUsersRecordData(
    email: user.email ??
        FirebaseAuth.instance.currentUser?.email ??
        user.providerData.firstOrNull?.email,
    displayName:
        user.displayName ?? FirebaseAuth.instance.currentUser?.displayName,
    photoUrl: user.photoURL,
    uid: user.uid,
    phoneNumber: user.phoneNumber,
    createdTime: getCurrentTimestamp,
  );

  await userRecord.set(userData);
  currentUserDocument = UsersRecord.getDocumentFromData(userData, userRecord);
}

Future updateUserDocument({final String? email}) async {
  await currentUserDocument?.reference
      .update(createUsersRecordData(email: email));
}
