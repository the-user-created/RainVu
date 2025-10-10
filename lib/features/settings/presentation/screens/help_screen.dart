import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/common/domain/coming_soon_args.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/settings/application/app_reset_provider.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:rain_wise/features/settings/presentation/widgets/danger_zone_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/contact_support_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/help/ticket_sheet.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/adaptive_ui_helpers.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/dialogs/app_alert_dialog.dart";

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

  Future<void> _showResetConfirmationDialog(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => const _ResetDialog(),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(appResetServiceProvider.notifier).resetApp();

        ref.invalidate(userPreferencesProvider);

        if (context.mounted) {
          showSnackbar(l10n.resetSuccessSnackbar, type: MessageType.success);
        }
      } catch (e) {
        if (context.mounted) {
          showSnackbar(l10n.resetErrorSnackbar(e), type: MessageType.error);
        }
      }
    }
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
            SettingsSectionHeader(title: l10n.changelogSectionLegal),
            SettingsCard(
              children: [
                SettingsListTile(
                  leading: const Icon(Icons.policy_outlined),
                  title: l10n.settingsSupportLegalPrivacyPolicy,
                  onTap: () => const ComingSoonRoute(
                    $extra: ComingSoonScreenArgs(pageTitle: "Privacy Policy"),
                  ).push(context),
                ),
                SettingsListTile(
                  leading: const Icon(Icons.gavel_rounded),
                  title: l10n.settingsSupportLegalTermsOfService,
                  onTap: () => const ComingSoonRoute(
                    $extra: ComingSoonScreenArgs(pageTitle: "Terms of Service"),
                  ).push(context),
                ),
                SettingsListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: l10n.settingsSupportLegalOssLicenses,
                  onTap: () => const OssLicensesRoute().push(context),
                ),
              ],
            ),
            SettingsSectionHeader(title: l10n.settingsSectionDangerZone),
            DangerZoneCard(
              onReset: () => _showResetConfirmationDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResetDialog extends StatefulWidget {
  const _ResetDialog();

  @override
  State<_ResetDialog> createState() => _ResetDialogState();
}

class _ResetDialogState extends State<_ResetDialog> {
  final _confirmationController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _confirmationController.addListener(() {
      final bool isEnabled = _confirmationController.text == "RESET";
      if (isEnabled != _isButtonEnabled) {
        setState(() => _isButtonEnabled = isEnabled);
      }
    });
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return AppAlertDialog(
      title: l10n.resetDialogTitle,
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(l10n.resetDialogContent),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmationController,
              decoration: InputDecoration(
                hintText: l10n.resetDialogTextFieldHint,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (final value) =>
                  (value != null && value.isNotEmpty && value != "RESET")
                  ? l10n.resetDialogValidationError
                  : null,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        AppButton(
          style: AppButtonStyle.destructive,
          onPressed: _isButtonEnabled
              ? () => Navigator.of(context).pop(true)
              : null,
          label: l10n.resetDialogConfirmButton,
          size: AppButtonSize.small,
        ),
      ],
    );
  }
}
