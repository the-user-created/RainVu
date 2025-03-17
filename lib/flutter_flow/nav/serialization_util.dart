import "dart:convert";

import "package:flutter/material.dart";
import "package:from_css_color/from_css_color.dart";

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
  final dynamic param,
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
      case ParamType.string:
        data = param;
      case ParamType.bool:
        data = param ? "true" : "false";
      case ParamType.dateTime:
        data = (param as DateTime).millisecondsSinceEpoch.toString();
      case ParamType.dateTimeRange:
        data = dateTimeRangeToString(param as DateTimeRange);
      case ParamType.latLng:
        data = (param as LatLng).serialize();
      case ParamType.color:
        data = (param as Color).toCssString();
      case ParamType.ffPlace:
        data = placeToString(param as FFPlace);
      case ParamType.ffUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.json:
        data = json.encode(param);
      case ParamType.documentReference:
        data = _serializeDocumentReference(param as DocumentReference);
      case ParamType.document:
        final DocumentReference<Object?> reference =
            (param as FirestoreRecord).reference;
        data = _serializeDocumentReference(reference);

      case ParamType._enum:
        data = (param is Enum) ? param.serialize() : null;
    }
    return data;
  } on Exception catch (e) {
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
  final buffer = StringBuffer();
  final List<String> docIds = refStr.split(_kDocIdDelimeter);
  for (int i = 0; i < docIds.length && i < collectionNamePath.length; i++) {
    buffer.write("/${collectionNamePath[i]}/${docIds[i]}");
  }
  return FirebaseFirestore.instance.doc(buffer.toString());
}

enum ParamType {
  int,
  double,
  string,
  bool,
  dateTime,
  dateTimeRange,
  latLng,
  color,
  ffPlace,
  ffUploadedFile,
  json,
  document,
  documentReference,
  _enum,
}

dynamic deserializeParam<T>(
  final String? param,
  final ParamType paramType, {
  final bool isList = false,
  final List<String>? collectionNamePath,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final dynamic paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .whereType<String>()
          .map((final p) => p)
          .map((final p) => deserializeParam<T>(p, paramType,
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
      case ParamType.string:
        return param;
      case ParamType.bool:
        return param == "true";
      case ParamType.dateTime:
        final int? milliseconds = int.tryParse(param);
        return milliseconds != null
            ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
            : null;
      case ParamType.dateTimeRange:
        return dateTimeRangeFromString(param);
      case ParamType.latLng:
        return latLngFromString(param);
      case ParamType.color:
        return fromCssColor(param);
      case ParamType.ffPlace:
        return placeFromString(param);
      case ParamType.ffUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.json:
        return json.decode(param);
      case ParamType.documentReference:
        return _deserializeDocumentReference(param, collectionNamePath ?? []);
      case ParamType._enum:
        return deserializeEnum<T>(param);
      case ParamType.document:
        return null;
    }
  } on Exception catch (e) {
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
      } on Exception catch (_) {}
      return Future.wait(
        docIds.map(
          (final ids) => _deserializeDocumentReference(ids, collectionNamePath)
              .get()
              .then(recordBuilder),
        ),
      ).then((final docs) =>
          docs.where((final d) => d != null).map((final d) => d!).toList());
    };
