import "dart:convert";

import "package:flutter/material.dart";

import "package:rain_wise/backend/backend.dart";

import "package:rain_wise/backend/schema/enums/enums.dart";

import "package:rain_wise/flutter_flow/place.dart";
import "package:rain_wise/flutter_flow/uploaded_file.dart";

/// SERIALIZATION HELPERS

String dateTimeRangeToString(final DateTimeRange dateTimeRange) {
  final startStr = dateTimeRange.start.millisecondsSinceEpoch.toString();
  final endStr = dateTimeRange.end.millisecondsSinceEpoch.toString();
  return "$startStr|$endStr";
}

String placeToString(final FFPlace place) => jsonEncode({
      "latLng": place.latLng.serialize(),
      "name": place.name,
      "address": place.address,
      "city": place.city,
      "state": place.state,
      "country": place.country,
      "zipCode": place.zipCode,
    });

String uploadedFileToString(final FFUploadedFile uploadedFile) =>
    uploadedFile.serialize();

const _kDocIdDelimeter = "|";

String _serializeDocumentReference(final DocumentReference ref) {
  final docIds = <String>[];
  DocumentReference? currentRef = ref;
  while (currentRef != null) {
    docIds.add(currentRef.id);
    // Get the parent document (catching any errors that arise).
    currentRef = safeGet<DocumentReference?>(() => currentRef?.parent.parent);
  }
  // Reverse the list to get the correct ordering.
  return docIds.reversed.join(_kDocIdDelimeter);
}

String? serializeParam(
  final param,
  final ParamType paramType, {
  final bool isList = false,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final List<String> serializedValues = (param as Iterable)
          .map((final p) => serializeParam(p, paramType))
          .where((final p) => p != null)
          .map((final p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    String? data;
    switch (paramType) {
      case ParamType.int:
        data = param.toString();
      case ParamType.double:
        data = param.toString();
      case ParamType.String:
        data = param;
      case ParamType.bool:
        data = param ? "true" : "false";
      case ParamType.DateTime:
        data = (param as DateTime).millisecondsSinceEpoch.toString();
      case ParamType.DateTimeRange:
        data = dateTimeRangeToString(param as DateTimeRange);
      case ParamType.LatLng:
        data = (param as LatLng).serialize();
      case ParamType.Color:
        data = (param as Color).toCssString();
      case ParamType.FFPlace:
        data = placeToString(param as FFPlace);
      case ParamType.FFUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.JSON:
        data = json.encode(param);
      case ParamType.DocumentReference:
        data = _serializeDocumentReference(param as DocumentReference);
      case ParamType.Document:
        final DocumentReference<Object?> reference =
            (param as FirestoreRecord).reference;
        data = _serializeDocumentReference(reference);

      case ParamType.Enum:
        data = (param is Enum) ? param.serialize() : null;
    }
    return data;
  } catch (e) {
    debugPrint("Error serializing parameter: $e");
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

DateTimeRange? dateTimeRangeFromString(final String dateTimeRangeStr) {
  final List<String> pieces = dateTimeRangeStr.split("|");
  if (pieces.length != 2) {
    return null;
  }
  return DateTimeRange(
    start: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.first)),
    end: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.last)),
  );
}

LatLng? latLngFromString(final String? latLngStr) {
  final List<String>? pieces = latLngStr?.split(",");
  if (pieces == null || pieces.length != 2) {
    return null;
  }
  return LatLng(
    double.parse(pieces.first.trim()),
    double.parse(pieces.last.trim()),
  );
}

FFPlace placeFromString(final String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final Map<String, dynamic> data = {
    "latLng": serializedData.containsKey("latLng")
        ? latLngFromString(serializedData["latLng"] as String)
        : const LatLng(0, 0),
    "name": serializedData["name"] ?? "",
    "address": serializedData["address"] ?? "",
    "city": serializedData["city"] ?? "",
    "state": serializedData["state"] ?? "",
    "country": serializedData["country"] ?? "",
    "zipCode": serializedData["zipCode"] ?? "",
  };
  return FFPlace(
    latLng: data["latLng"] as LatLng,
    name: data["name"] as String,
    address: data["address"] as String,
    city: data["city"] as String,
    state: data["state"] as String,
    country: data["country"] as String,
    zipCode: data["zipCode"] as String,
  );
}

FFUploadedFile uploadedFileFromString(final String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

DocumentReference _deserializeDocumentReference(
  final String refStr,
  final List<String> collectionNamePath,
) {
  var path = "";
  final List<String> docIds = refStr.split(_kDocIdDelimeter);
  for (int i = 0; i < docIds.length && i < collectionNamePath.length; i++) {
    path += "/${collectionNamePath[i]}/${docIds[i]}";
  }
  return FirebaseFirestore.instance.doc(path);
}

enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,
  Document,
  DocumentReference,
  Enum,
}

dynamic deserializeParam<T>(
  final String? param,
  final ParamType paramType,
  final bool isList, {
  final List<String>? collectionNamePath,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .whereType<String>()
          .map((final p) => p)
          .map((final p) => deserializeParam<T>(p, paramType, false,
              collectionNamePath: collectionNamePath))
          .where((final p) => p != null)
          .map((final p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.int:
        return int.tryParse(param);
      case ParamType.double:
        return double.tryParse(param);
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param == "true";
      case ParamType.DateTime:
        final int? milliseconds = int.tryParse(param);
        return milliseconds != null
            ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
            : null;
      case ParamType.DateTimeRange:
        return dateTimeRangeFromString(param);
      case ParamType.LatLng:
        return latLngFromString(param);
      case ParamType.Color:
        return fromCssColor(param);
      case ParamType.FFPlace:
        return placeFromString(param);
      case ParamType.FFUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.JSON:
        return json.decode(param);
      case ParamType.DocumentReference:
        return _deserializeDocumentReference(param, collectionNamePath ?? []);

      case ParamType.Enum:
        return deserializeEnum<T>(param);

      default:
        return null;
    }
  } catch (e) {
    debugPrint("Error deserializing parameter: $e");
    return null;
  }
}

Future<dynamic> Function(String) getDoc(
  final List<String> collectionNamePath,
  final RecordBuilder recordBuilder,
) =>
    (final String ids) => _deserializeDocumentReference(ids, collectionNamePath)
        .get()
        .then(recordBuilder);

Future<List<T>> Function(String) getDocList<T>(
  final List<String> collectionNamePath,
  final RecordBuilder<T> recordBuilder,
) =>
    (final String idsList) {
      List<String> docIds = [];
      try {
        final ids = json.decode(idsList) as Iterable;
        docIds = ids.whereType<String>().map((final d) => d).toList();
      } catch (_) {}
      return Future.wait(
        docIds.map(
          (final ids) => _deserializeDocumentReference(ids, collectionNamePath)
              .get()
              .then(recordBuilder),
        ),
      ).then((final docs) =>
          docs.where((final d) => d != null).map((final d) => d!).toList());
    };
