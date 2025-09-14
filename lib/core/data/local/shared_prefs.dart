import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "shared_prefs.g.dart";

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(final Ref ref) =>
    SharedPreferences.getInstance();
