import "dart:convert";

import "package:flutter/material.dart";
import "package:from_css_color/from_css_color.dart";

import "package:rain_wise/backend/schema/enums/enums.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

export "package:collection/collection.dart" show ListEquality;
export "package:flutter/material.dart" show Color, Colors;
export "package:from_css_color/from_css_color.dart";
export "/backend/schema/enums/enums.dart" show FFEnumExtensions;

typedef StructBuilder<T> = T Function(Map<String, dynamic> data);

abstract class BaseStruct {
  Map<String, dynamic> toSerializableMap();

  String serialize() => json.encode(toSerializableMap());
}

List<T>? getStructList<T>(
  final value,
  final StructBuilder<T> structBuilder,
) =>
    value is! List
        ? null
        : value.whereType<Map<String, dynamic>>().map(structBuilder).toList();

List<T>? getEnumList<T>(final value) => value is! List
    ? null
    : value.map((final e) => deserializeEnum<T>(e)).withoutNulls;

Color? getSchemaColor(final value) => value is String
    ? fromCssColor(value)
    : value is Color
        ? value
        : null;

List<Color>? getColorsList(final value) =>
    value is! List ? null : value.map(getSchemaColor).withoutNulls;

List<T>? getDataList<T>(final value) =>
    value is! List ? null : value.map((final e) => castToType<T>(e)!).toList();
