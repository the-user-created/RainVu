import "dart:ui";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:from_css_color/from_css_color.dart";
import "package:rain_wise/backend/schema/enums/enums.dart";

import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

typedef RecordBuilder<T> = T Function(DocumentSnapshot snapshot);

abstract class FirestoreRecord {
  FirestoreRecord(this.reference, this.snapshotData);

  Map<String, dynamic> snapshotData;
  DocumentReference reference;
}

abstract class FFFirebaseStruct {
  FFFirebaseStruct(this.firestoreUtilData);

  /// Utility class for Firestore updates
  FirestoreUtilData firestoreUtilData = const FirestoreUtilData();
}

class FirestoreUtilData {
  const FirestoreUtilData({
    this.fieldValues = const {},
    this.clearUnsetFields = true,
    this.create = false,
    this.delete = false,
  });

  final Map<String, dynamic> fieldValues;
  final bool clearUnsetFields;
  final bool create;
  final bool delete;

  static String get name => "firestoreUtilData";
}

Map<String, dynamic> mapFromFirestore(final Map<String, dynamic> data) =>
    mergeNestedFields(data)
        .where((final k, final _) => k != FirestoreUtilData.name)
        .map((final key, value) {
      // Handle Timestamp
      if (value is Timestamp) {
        value = value.toDate();
      }
      // Handle list of Timestamp
      if (value is Iterable && value.isNotEmpty && value.first is Timestamp) {
        value = value.map((final v) => (v as Timestamp).toDate()).toList();
      }
      // Handle GeoPoint
      if (value is GeoPoint) {
        value = value.toLatLng();
      }
      // Handle list of GeoPoint
      if (value is Iterable && value.isNotEmpty && value.first is GeoPoint) {
        value = value.map((final v) => (v as GeoPoint).toLatLng()).toList();
      }
      // Handle nested data.
      if (value is Map) {
        value = mapFromFirestore(value as Map<String, dynamic>);
      }
      // Handle list of nested data.
      if (value is Iterable && value.isNotEmpty && value.first is Map) {
        value = value
            .map((final v) => mapFromFirestore(v as Map<String, dynamic>))
            .toList();
      }
      return MapEntry(key, value);
    });

Map<String, dynamic> mapToFirestore(final Map<String, dynamic> data) => data
        .where((final k, final v) => k != FirestoreUtilData.name)
        .map((final key, value) {
      // Handle GeoPoint
      if (value is LatLng) {
        value = value.toGeoPoint();
      }
      // Handle list of GeoPoint
      if (value is Iterable && value.isNotEmpty && value.first is LatLng) {
        value = value.map((final v) => (v as LatLng).toGeoPoint()).toList();
      }
      // Handle Color
      if (value is Color) {
        value = value.toCssString();
      }
      // Handle list of Color
      if (value is Iterable && value.isNotEmpty && value.first is Color) {
        value = value.map((final v) => (v as Color).toCssString()).toList();
      } // Handle Enums.
      if (value is Enum) {
        value = value.serialize();
      }
      // Handle list of Enums.
      if (value is Iterable && value.isNotEmpty && value.first is Enum) {
        value = value.map((final v) => (v as Enum).serialize()).toList();
      }
      // Handle nested data.
      if (value is Map) {
        value = mapToFirestore(value as Map<String, dynamic>);
      }
      // Handle list of nested data.
      if (value is Iterable && value.isNotEmpty && value.first is Map) {
        value = value
            .map((final v) => mapToFirestore(v as Map<String, dynamic>))
            .toList();
      }
      return MapEntry(key, value);
    });

List<GeoPoint>? convertToGeoPointList(final List<LatLng>? list) =>
    list?.map((final e) => e.toGeoPoint()).toList();

extension GeoPointExtension on LatLng {
  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}

extension LatLngExtension on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

DocumentReference toRef(final String ref) =>
    FirebaseFirestore.instance.doc(ref);

T? safeGet<T>(final T Function() func, [final Function(Exception)? reportError]) {
  try {
    return func();
  } on Exception catch (e) {
    reportError?.call(e);
  }
  return null;
}

Map<String, dynamic> mergeNestedFields(final Map<String, dynamic> data) {
  final Map<String, dynamic> nestedData =
      data.where((final k, final _) => k.contains("."));
  final Set<String> fieldNames =
      nestedData.keys.map((final k) => k.split(".").first).toSet();
  // Remove nested values (e.g. 'foo.bar') and merge them into a map.
  data.removeWhere((final k, final _) => k.contains("."));
  for (final name in fieldNames) {
    final Map<String, dynamic> mergedValues = mergeNestedFields(
      nestedData.where((final k, final _) => k.split(".").first == name).map(
          (final k, final v) => MapEntry(k.split(".").skip(1).join("."), v)),
    );
    final dynamic existingValue = data[name];
    data[name] = {
      if (existingValue != null && existingValue is Map)
        ...existingValue as Map<String, dynamic>,
      ...mergedValues,
    };
  }
  // Merge any nested maps inside any of the fields as well.
  data.where((final _, final v) => v is Map).forEach((final k, final v) {
    data[k] = mergeNestedFields(v as Map<String, dynamic>);
  });

  return data;
}

extension _WhereMapExtension<K, V> on Map<K, V> {
  Map<K, V> where(final bool Function(K, V) test) =>
      Map.fromEntries(entries.where((final e) => test(e.key, e.value)));
}
