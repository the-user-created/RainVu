import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/contact_support_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/ticket_sheet.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/adaptive_ui_helpers.dart";

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  void _showTicketSheet(
    final BuildContext context, {
    final TicketCategory? initialCategory,
  }) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final _) => TicketSheet(initialCategory: initialCategory),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpTitle, style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            SettingsSectionHeader(title: l10n.helpGetHelpSection),
            SettingsCard(
              children: [
                ContactSupportTile(
                  title: l10n.helpContactEmailSupport,
                  subtitle: "support@emberworks.dev",
                  icon: Icons.mail_outline,
                  url: "mailto:support@emberworks.dev",
                ),
                SettingsListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: l10n.helpReportProblem,
                  onTap: () => _showTicketSheet(
                    context,
                    initialCategory: TicketCategory.bugReport,
                  ),
                ),
                SettingsListTile(
                  leading: const Icon(Icons.feedback_outlined),
                  title: l10n.helpSendFeedback,
                  onTap: () => _showTicketSheet(
                    context,
                    initialCategory: TicketCategory.generalFeedback,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
