import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/common/domain/coming_soon_args.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/features/settings/application/app_reset_provider.dart";
import "package:rain_wise/features/settings/application/preferences_provider.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:rain_wise/features/settings/presentation/widgets/app_info_footer.dart";
import "package:rain_wise/features/settings/presentation/widgets/danger_zone_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/forms/app_segmented_control.dart";

// TODO: Add a "What's New" tile in the "Support & Legal" section that opens a dialog or screen showing the latest release notes.
// TODO: Use the in_app_review package to prompt for a rating without leaving the app.
// TODO: "Tell a friend" Use the share_plus package to open the native share sheet with a link to the app store page.

/// The main settings screen, composed of smaller, reusable widgets.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
      data: (final preferences) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l10n.settingsAppearanceTheme,
                style: theme.textTheme.titleMedium,
              ),
            ),
            SizedBox(
              width: 220,
              child: AppSegmentedControl<AppThemeMode>(
                selectedValue: preferences.themeMode,
                onSelectionChanged: (final value) {
                  ref
                      .read(userPreferencesProvider.notifier)
                      .setThemeMode(value);
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementUnitSetting(
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
      data: (final preferences) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l10n.settingsPreferencesMeasurementUnit,
                style: theme.textTheme.titleMedium,
              ),
            ),
            SizedBox(
              width: 150,
              child: AppSegmentedControl<MeasurementUnit>(
                selectedValue: preferences.measurementUnit,
                onSelectionChanged: (final value) {
                  ref
                      .read(userPreferencesProvider.notifier)
                      .setMeasurementUnit(value);
                },
                segments: [
                  SegmentOption(
                    value: MeasurementUnit.mm,
                    label: Text(l10n.unitMM),
                  ),
                  SegmentOption(
                    value: MeasurementUnit.inch,
                    label: Text(l10n.unitIn),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          showSnackbar(context, l10n.resetSuccessSnackbar);
        }
      } catch (e) {
        if (context.mounted) {
          showSnackbar(context, l10n.resetErrorSnackbar(e));
        }
      }
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.settingsTitle),
        elevation: 2,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SettingsSectionHeader(title: l10n.settingsSectionAppearance),
          SettingsCard(children: [_buildThemeSetting(context, ref, l10n)]),
          SettingsSectionHeader(title: l10n.settingsSectionPreferences),
          SettingsCard(
            children: [_buildMeasurementUnitSetting(context, ref, l10n)],
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
          SettingsSectionHeader(title: l10n.settingsSectionSupportLegal),
          SettingsCard(
            children: [
              SettingsListTile(
                leading: const Icon(Icons.help_outline_rounded),
                title: l10n.settingsSupportLegalHelp,
                onTap: () => const HelpRoute().push(context),
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

    return AlertDialog(
      title: Text(l10n.resetDialogTitle),
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
