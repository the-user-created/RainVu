import "package:flutter/material.dart";

class FFAppState extends ChangeNotifier {
  factory FFAppState() => _instance;

  FFAppState._internal();

  static FFAppState _instance = FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(final VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
