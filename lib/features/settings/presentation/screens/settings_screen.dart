import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/settings/presentation/widgets/app_info_footer.dart";
import "package:rain_wise/features/settings/presentation/widgets/preferences_sheet.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/forms/app_segmented_control.dart";

/// The main settings screen, composed of smaller, reusable widgets.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showPreferencesSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (final _) => const PreferencesSheet(),
    );
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
                onSelectionChanged: (final value) async {
                  await ref
                      .read(userPreferencesProvider.notifier)
                      .setThemeMode(value);
                  showSnackbar(
                    l10n.settingsUpdatedSuccess,
                    type: MessageType.success,
                  );
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
                  onTap: () => showSnackbar(l10n.featureNotImplementedSnackbar),
                ),
                SettingsListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: l10n.settingsSupportDevelopmentShareApp,
                  onTap: () => showSnackbar(l10n.featureNotImplementedSnackbar),
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
                  leading: const Icon(Icons.new_releases_outlined),
                  title: l10n.settingsSupportLegalWhatsNew,
                  onTap: () => const ChangelogRoute().push(context),
                ),
              ],
            ),
            const AppInfoFooter(),
          ],
        ),
      ),
    );
  }
}
