import 'package:flutter/material.dart';
import '/backend/schema/enums/enums.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  WeatherIcon? _todayWeather = WeatherIcon.sunny;

  WeatherIcon? get todayWeather => _todayWeather;

  set todayWeather(WeatherIcon? value) {
    _todayWeather = value;
  }

  dynamic _lastEntry = jsonDecode(
      '{\"date\":\"Feb 5, 2025\",\"amount\":\"12 mm\",\"notes\":\"Heavy rain in the morning, drizzle in the evening\",\"location\":\"Farm A - Central Field\"}');

  dynamic get lastEntry => _lastEntry;

  set lastEntry(dynamic value) {
    _lastEntry = value;
  }

  bool _startDateShown = false;

  bool get startDateShown => _startDateShown;

  set startDateShown(bool value) {
    _startDateShown = value;
  }

  bool _endDateShown = false;

  bool get endDateShown => _endDateShown;

  set endDateShown(bool value) {
    _endDateShown = value;
  }
}
