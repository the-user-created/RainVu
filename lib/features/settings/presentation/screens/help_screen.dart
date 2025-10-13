import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/help_action_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/ticket_sheet.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/adaptive_ui_helpers.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:url_launcher/url_launcher.dart";

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  void _showTicketSheet(
    final BuildContext context, {
    required final TicketCategory initialCategory,
  }) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final _) => TicketSheet(initialCategory: initialCategory),
    );
  }

  Future<void> _launchUrl(final BuildContext context, final String url) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Uri uri = Uri.parse(url);

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
        reason: "Failed to launch URL: $url",
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
        onTap: () => _showTicketSheet(
          context,
          initialCategory: TicketCategory.bugReport,
        ),
      ),
      HelpActionCard(
        icon: Icons.lightbulb_outline_rounded,
        title: l10n.helpSuggestIdeaTitle,
        subtitle: l10n.helpSuggestIdeaSubtitle,
        onTap: () => _showTicketSheet(
          context,
          initialCategory: TicketCategory.featureRequest,
        ),
      ),
      HelpActionCard(
        icon: Icons.mail_outline_rounded,
        title: l10n.helpEmailSupportTitle,
        subtitle: l10n.helpEmailSupportSubtitle,
        onTap: () => _launchUrl(context, "mailto:support@rainwiseapp.com"),
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
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
              child: Text(
                l10n.helpIntro,
                style: theme.textTheme.bodyLarge?.copyWith(
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
