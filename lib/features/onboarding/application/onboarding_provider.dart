import "package:rain_wise/core/data/local/shared_prefs.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "onboarding_provider.g.dart";

@Riverpod(keepAlive: true)
class Onboarding extends _$Onboarding {
  static const onboardingCompleteKey = "onboarding_complete";

  @override
  Future<bool> build() async {
    final SharedPreferences prefs = await ref.watch(
      sharedPreferencesProvider.future,
    );
    return prefs.getBool(onboardingCompleteKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    final SharedPreferences prefs = await ref.watch(
      sharedPreferencesProvider.future,
    );
    await prefs.setBool(onboardingCompleteKey, true);
    state = const AsyncData(true);
  }
}
