import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/shared_prefs.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "app_reset_provider.g.dart";

@riverpod
class AppResetService extends _$AppResetService {
  @override
  void build() {
    // No-op
  }

  Future<void> resetApp() async {
    final AppDatabase db = ref.read(appDatabaseProvider);
    final SharedPreferences prefs = await ref.read(
      sharedPreferencesProvider.future,
    );

    await db.deleteAllData();
    await prefs.clear();
  }
}
