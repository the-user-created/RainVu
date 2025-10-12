import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:in_app_review/in_app_review.dart";
import "package:rain_wise/common/domain/coming_soon_args.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/settings/application/app_reset_provider.dart";
import "package:rain_wise/features/settings/presentation/widgets/app_info_footer.dart";
import "package:rain_wise/features/settings/presentation/widgets/danger_zone_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/preferences_sheet.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/utils/adaptive_ui_helpers.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/dialogs/app_alert_dialog.dart";
import "package:rain_wise/shared/widgets/forms/app_segmented_control.dart";
import "package:share_plus/share_plus.dart";

/// The main settings screen, composed of smaller, reusable widgets.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showPreferencesSheet(final BuildContext context) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final _) => const PreferencesSheet(),
    );
  }

  // TODO: Proper testing of in-app review flow on real devices.
  // TODO: Proper testing of share plus with URLs on real devices.

  /// Handles the "Leave a Review" action.
  ///
  /// It first checks if the in-app review dialog is available. If so, it
  /// requests the review. Otherwise, it attempts to open the app's store
  /// listing as a fallback. If that fails (e.g., app not published),
  /// it shows a snackbar.
  Future<void> _leaveReview(final BuildContext context) async {
    final InAppReview inAppReview = InAppReview.instance;
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (await inAppReview.isAvailable()) {
      // This will open the in-app review dialog. The OS handles quotas,
      // so it's safe to call; it might not appear if the user has reviewed
      // recently or opted out.
      await inAppReview.requestReview();
    } else {
      // Fallback for when the in-app review is not available,
      // e.g., during development on Android or on unsupported devices.
      try {
        // For a published app, you would add your appStoreId here.
        await inAppReview.openStoreListing();
      } catch (_) {
        if (context.mounted) {
          showSnackbar(l10n.reviewNotAvailable);
        }
      }
    }
  }

  /// Handles the "Share RainWise" action.
  ///
  /// Summons the platform's native share sheet. It calculates the
  /// [sharePositionOrigin] for iPad compatibility.
  Future<void> _shareApp(final BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final RenderBox? box = context.findRenderObject() as RenderBox?;

    // The sharePositionOrigin is required for iPads to prevent crashes and
    // anchor the share popover to the button that triggered it.
    final Rect? sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    await SharePlus.instance.share(
      ShareParams(
        text: l10n.shareAppText,
        subject: l10n.shareAppSubject,
        sharePositionOrigin: sharePositionOrigin,
      ),
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

  Widget _buildThemeSetting(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<UserPreferences> userPreferences = ref.watch(
      userPreferencesProvider,
    );

    return userPreferences.when(
      loading: () => const ListTile(title: Text("Loading...")),
      error: (final err, final stack) => ListTile(title: Text("Error: $err")),
      data: (final preferences) {
        final Widget label = Text(
          l10n.settingsAppearanceTheme,
          style: theme.textTheme.titleMedium,
        );

        final Widget control = AppSegmentedControl<AppThemeMode>(
          selectedValue: preferences.themeMode,
          onSelectionChanged: (final value) {
            ref.read(userPreferencesProvider.notifier).setThemeMode(value);
          },
          segments: [
            SegmentOption(
              value: AppThemeMode.light,
              label: Text(l10n.settingsThemeLight),
            ),
            SegmentOption(
              value: AppThemeMode.dark,
              label: Text(l10n.settingsThemeDark),
            ),
            SegmentOption(
              value: AppThemeMode.system,
              label: Text(l10n.settingsThemeSystem),
            ),
          ],
        );

        return LayoutBuilder(
          builder: (final context, final constraints) {
            const double breakpoint = 420;

            if (constraints.maxWidth > breakpoint) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: label),
                    const SizedBox(width: 16),
                    SizedBox(width: 220, child: control),
                  ],
                ),
              );
            } else {
              // Use Column for narrower screens or large text
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label,
                    const SizedBox(height: 12),
                    control, // This will take the full width
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.settingsTitle, style: theme.textTheme.headlineLarge),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SettingsSectionHeader(title: l10n.settingsSectionAppearance),
            SettingsCard(children: [_buildThemeSetting(context, ref, l10n)]),
            SettingsSectionHeader(title: l10n.settingsSectionPreferences),
            SettingsCard(
              children: [
                SettingsListTile(
                  leading: const Icon(Icons.tune_rounded),
                  title: l10n.settingsUnitsAndAnalysis,
                  onTap: () => _showPreferencesSheet(context),
                ),
              ],
            ),
            SettingsSectionHeader(title: l10n.settingsSectionDataManagement),
            SettingsCard(
              children: [
                SettingsListTile(
                  leading: const Icon(Icons.import_export_rounded),
                  title: l10n.settingsDataManagementExportImport,
                  onTap: () => const DataToolsRoute().push(context),
                ),
              ],
            ),
            SettingsSectionHeader(
              title: l10n.settingsSectionSupportDevelopment,
            ),
            SettingsCard(
              children: [
                SettingsListTile(
                  leading: const Icon(Icons.star_outline_rounded),
                  title: l10n.settingsSupportDevelopmentLeaveReview,
                  onTap: () => _leaveReview(context),
                ),
                Builder(
                  builder: (final builderContext) => SettingsListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: l10n.settingsSupportDevelopmentShareApp,
                    onTap: () => _shareApp(builderContext),
                  ),
                ),
              ],
            ),
            SettingsSectionHeader(title: l10n.settingsSectionAboutAndSupport),
            SettingsCard(
              children: [
                SettingsListTile(
                  leading: const Icon(Icons.help_outline_rounded),
                  title: l10n.settingsSupportLegalHelp,
                  onTap: () => const HelpRoute().push(context),
                ),
                SettingsListTile(
                  leading: const Icon(Icons.new_releases_outlined),
                  title: l10n.settingsSupportLegalWhatsNew,
                  onTap: () => const ChangelogRoute().push(context),
                ),
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
            const AppInfoFooter(),
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
  late String _confirmationText;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _confirmationText = AppLocalizations.of(
      context,
    ).resetDialogConfirmationText;

    _confirmationController
      ..removeListener(_validateInput)
      ..addListener(_validateInput);
  }

  void _validateInput() {
    final bool isEnabled = _confirmationController.text == _confirmationText;
    if (isEnabled != _isButtonEnabled) {
      setState(() => _isButtonEnabled = isEnabled);
    }
  }

  @override
  void dispose() {
    _confirmationController
      ..removeListener(_validateInput)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return AppAlertDialog(
      title: Text(l10n.resetDialogTitle),
      content: ListBody(
        children: <Widget>[
          Text(l10n.resetDialogContent(_confirmationText)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmationController,
            decoration: InputDecoration(
              hintText: l10n.resetDialogTextFieldHint(_confirmationText),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (final value) {
              if (value != null &&
                  value.isNotEmpty &&
                  value != _confirmationText) {
                return l10n.resetDialogValidationError(_confirmationText);
              }
              return null;
            },
          ),
        ],
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
