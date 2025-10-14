// lib/features/onboarding/presentation/widgets/welcome_step.dart
import "package:flutter/material.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.water_drop_outlined,
            size: 100,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.onboardingWelcomeTitle(l10n.appName),
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingWelcomeSubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AppButton(
            onPressed: onNext,
            label: l10n.onboardingButtonNext,
            isExpanded: true,
            style: AppButtonStyle.secondary,
          ),
        ],
      ),
    );
  }
}
