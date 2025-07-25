import "dart:convert";

import "package:flutter/material.dart";
import "package:from_css_color/from_css_color.dart";

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
      case ParamType.color:
        data = (param as Color).toCssString();
      case ParamType.ffUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.json:
        data = json.encode(param);
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

FFUploadedFile uploadedFileFromString(final String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

enum ParamType {
  int,
  double,
  string,
  bool,
  dateTime,
  dateTimeRange,
  color,
  ffUploadedFile,
  json,
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
      case ParamType.color:
        return fromCssColor(param);
      case ParamType.ffUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.json:
        return json.decode(param);
    }
  } on Exception catch (e) {
    debugPrint("Error deserializing parameter: $e");
    return null;
  }
}
