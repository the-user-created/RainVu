import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/settings/domain/faq.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/contact_support_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/faq_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/ticket_sheet.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  void _showTicketSheet(
    final BuildContext context, {
    final TicketCategory? initialCategory,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: TicketSheet(initialCategory: initialCategory),
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<Faq> faqs = [
      Faq(question: l10n.faq1Question, answer: l10n.faq1Answer),
      Faq(question: l10n.faq2Question, answer: l10n.faq2Answer),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpTitle),
        elevation: 2,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          SettingsSectionHeader(title: l10n.helpSectionFaqs),
          SettingsCard(
            children: faqs
                .map(
                  (final faq) => FaqTile(
                    question: faq.question,
                    answer: faq.answer,
                  ),
                )
                .toList(),
          ),
          SettingsSectionHeader(title: l10n.helpSectionContactUs),
          SettingsCard(
            children: [
              ContactSupportTile(
                title: l10n.helpContactEmailSupport,
                subtitle: "support@rainwiseapp.com",
                icon: Icons.mail_outline,
                url: "mailto:support@rainwiseapp.com",
              ),
            ],
          ),
          SettingsSectionHeader(title: l10n.helpSectionImprove),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton(
                  onPressed: () => _showTicketSheet(
                    context,
                    initialCategory: TicketCategory.bugReport,
                  ),
                  label: l10n.helpReportProblemButton,
                  icon: const Icon(
                    Icons.report_problem_outlined,
                    color: Colors.white,
                  ),
                  style: AppButtonStyle.destructive,
                  isExpanded: true,
                ),
                const SizedBox(height: 12),
                AppButton(
                  onPressed: () => _showTicketSheet(
                    context,
                    initialCategory: TicketCategory.generalFeedback,
                  ),
                  label: l10n.helpSendFeedbackButton,
                  icon: const Icon(
                    Icons.feedback_outlined,
                    color: Colors.white,
                  ),
                  style: AppButtonStyle.secondary,
                  isExpanded: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
