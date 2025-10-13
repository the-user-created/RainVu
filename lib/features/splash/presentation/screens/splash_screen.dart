import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/features/onboarding/application/onboarding_provider.dart";

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.listen<AsyncValue<bool>>(onboardingProvider, (_, final next) {
      next.whenData((final isComplete) {
        if (isComplete) {
          const HomeRoute().go(context);
        } else {
          const OnboardingRoute().go(context);
        }
      });
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
