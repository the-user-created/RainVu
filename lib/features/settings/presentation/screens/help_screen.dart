import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:rainly/core/utils/snackbar_service.dart";
import "package:rainly/features/settings/application/settings_providers.dart";
import "package:rainly/features/settings/presentation/widgets/help/help_action_card.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/utils/ui_helpers.dart";
import "package:url_launcher/url_launcher.dart";

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  String? _encodeQueryParameters(final Map<String, String> params) => params
      .entries
      .map(
        (final e) =>
            "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}",
      )
      .join("&");

  Future<void> _launchEmail(
    final BuildContext context,
    final WidgetRef ref, {
    required final String subject,
    required final String body,
  }) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    String appInfoString = "Could not retrieve app version.";

    try {
      final PackageInfo packageInfo = await ref.read(appInfoProvider.future);
      appInfoString =
          "App Version: ${packageInfo.version}\nBuild: ${packageInfo.buildNumber}";
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to get PackageInfo for support email",
      );
    }

    final String finalBody = "$body\n\n---\n$appInfoString\n";

    final Uri uri = Uri(
      scheme: "mailto",
      path: "developer@emberworks.dev",
      query: _encodeQueryParameters(<String, String>{
        "subject": subject,
        "body": finalBody,
      }),
    );

    try {
      if (!await launchUrl(uri)) {
        if (!context.mounted) {
          return;
        }
        showSnackbar(l10n.urlLaunchError, type: MessageType.error);
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to launch mailto: URI",
      );
      if (context.mounted) {
        showSnackbar(l10n.urlLaunchError, type: MessageType.error);
      }
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    final List<Widget> helpCards = [
      HelpActionCard(
        icon: Icons.bug_report_outlined,
        title: l10n.helpReportBugTitle,
        subtitle: l10n.helpReportBugSubtitle,
        onTap: () {
          const String subject = "Bug Report: [Please describe the issue]";
          const String body =
              "Please provide as much detail as possible about the bug.\n\n"
              "What happened?\n\n"
              "What did you expect to happen?\n\n"
              "What steps can we take to reproduce it?\n1. \n2. \n3. \n";
          _launchEmail(context, ref, subject: subject, body: body);
        },
      ),
      HelpActionCard(
        icon: Icons.lightbulb_outline_rounded,
        title: l10n.helpSuggestIdeaTitle,
        subtitle: l10n.helpSuggestIdeaSubtitle,
        onTap: () {
          const String subject = "Feature Suggestion: [Your idea here]";
          const String body =
              "Please describe your idea and the problem it would solve.\n\n"
              "My idea is...\n\n"
              "This would be helpful because...\n\n";
          _launchEmail(context, ref, subject: subject, body: body);
        },
      ),
      HelpActionCard(
        icon: Icons.mail_outline_rounded,
        title: l10n.helpEmailSupportTitle,
        subtitle: l10n.helpEmailSupportSubtitle,
        onTap: () {
          const String subject = "Support Request";
          const String body = "How can we help you?\n\n";
          _launchEmail(context, ref, subject: subject, body: body);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpTitle, style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                l10n.helpIntro,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
              child: Text(
                l10n.helpSupportLanguageNotice,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ...helpCards.asMap().entries.map(
              (final entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: entry.value
                    .animate()
                    .fade(duration: 500.ms)
                    .slideY(
                      begin: 0.2,
                      duration: 400.ms,
                      delay: (entry.key * 100).ms,
                      curve: Curves.easeOutCubic,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
