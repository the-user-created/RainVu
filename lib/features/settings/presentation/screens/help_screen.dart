import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/contact_support_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/faq_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/ticket_sheet.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

// Dummy data for FAQs. In a real app, this might come from a remote source.
const _faqs = [
  {
    "q": "How do I add a new rain gauge?",
    "a":
        'Go to the Settings tab, tap on "Manage Rain Gauges", and then use the "+" button at the bottom to add a new gauge. Fill in the details and save.',
  },
  {
    "q": "How do I export my rainfall data?",
    "a":
        "Navigate to Settings > Data Export/Import. From there, you can choose your desired format (CSV, PDF, JSON) and export your complete rainfall history.",
  },
  {
    "q": "How do I set up notifications?",
    "a":
        'In the Settings tab, select "Notifications". You can enable or disable daily reminders, set the reminder time, and toggle other alerts like weekly summaries.',
  },
];

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
            color: FlutterFlowTheme.of(context).secondaryBackground,
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
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        iconTheme: IconThemeData(color: theme.primaryText),
        title: Text("Help & Support", style: theme.headlineMedium),
        elevation: 2,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          const SettingsSectionHeader(title: "FREQUENTLY ASKED QUESTIONS"),
          SettingsCard(
            children: _faqs
                .map(
                  (final faq) => FaqTile(
                    question: faq["q"]!,
                    answer: faq["a"]!,
                  ),
                )
                .toList(),
          ),
          const SettingsSectionHeader(title: "CONTACT US"),
          const SettingsCard(
            children: [
              ContactSupportTile(
                title: "Email Support",
                subtitle: "support@rainwiseapp.com",
                icon: Icons.mail_outline,
                url: "mailto:support@rainwiseapp.com",
              ),
            ],
          ),
          const SettingsSectionHeader(title: "HELP US IMPROVE"),
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
                  label: "Report a Problem",
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
                  label: "Send Feedback",
                  icon:
                      const Icon(Icons.feedback_outlined, color: Colors.white),
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
