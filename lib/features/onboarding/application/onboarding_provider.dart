import "package:rain_wise/app_constants.dart";
import "package:rain_wise/core/data/local/shared_prefs.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "onboarding_provider.g.dart";

@Riverpod(keepAlive: true)
class Onboarding extends _$Onboarding {
  @override
  Future<bool> build() async {
    final SharedPreferences prefs = await ref.watch(
      sharedPreferencesProvider.future,
    );
    return prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    final SharedPreferences prefs = await ref.watch(
      sharedPreferencesProvider.future,
    );
    await prefs.setBool(AppConstants.onboardingCompleteKey, true);
    state = const AsyncData(true);
  }
}
