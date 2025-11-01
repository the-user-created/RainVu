import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/firebase/telemetry_manager.dart";
import "package:rainvu/core/navigation/app_router.dart";
import "package:rainvu/core/utils/snackbar_service.dart";
import "package:rainvu/features/onboarding/application/onboarding_provider.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/utils/ui_helpers.dart";
import "package:rainvu/shared/widgets/buttons/app_button.dart";
import "package:url_launcher/url_launcher.dart";

class PermissionsStep extends ConsumerStatefulWidget {
  const PermissionsStep({super.key});

  @override
  ConsumerState<PermissionsStep> createState() => _PermissionsStepState();
}

class _PermissionsStepState extends ConsumerState<PermissionsStep> {
  bool _telemetryEnabled = true;

  Future<void> _onFinish() async {
    await ref
        .read(telemetryManagerProvider.notifier)
        .setTelemetryEnabled(_telemetryEnabled);
    await ref.read(onboardingProvider.notifier).completeOnboarding();

    if (mounted) {
      const HomeRoute().go(context);
    }
  }

  Future<void> _launchUrl(final String url) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Uri uri = Uri.parse(url);

    try {
      if (!await launchUrl(uri)) {
        if (mounted) {
          showSnackbar(l10n.urlLaunchError, type: MessageType.error);
        }
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to launch URL: $url",
      );
      if (mounted) {
        showSnackbar(l10n.urlLaunchError, type: MessageType.error);
      }
    }
  }

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
          Text(
            l10n.onboardingPermissionsTitle,
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SwitchListTile(
            title: Text(l10n.onboardingPermissionsShareTitle),
            subtitle: Text(l10n.onboardingPermissionsShareSubtitle),
            value: _telemetryEnabled,
            onChanged: (final value) {
              setState(() {
                _telemetryEnabled = value;
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          const SizedBox(height: 24),
          Semantics(
            label: l10n.onboardingPermissionsAgreementSemantics,
            child: ExcludeSemantics(
              child: Text.rich(
                TextSpan(
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    TextSpan(text: "${l10n.onboardingPermissionsAgreement} "),
                    TextSpan(
                      text: l10n.onboardingPermissionsPrivacyPolicy,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: theme.colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _launchUrl(
                          "https://github.com/the-user-created/RainVu/blob/main/PRIVACY.md",
                        ),
                    ),
                    TextSpan(text: " ${l10n.and} "),
                    TextSpan(
                      text: l10n.onboardingPermissionsTos,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: theme.colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _launchUrl(
                          "https://github.com/the-user-created/RainVu/blob/main/TERMS.md",
                        ),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Spacer(),
          AppButton(
            onPressed: _onFinish,
            label: l10n.onboardingButtonFinish,
            isExpanded: true,
            style: AppButtonStyle.secondary,
          ),
        ],
      ),
    );
  }
}
