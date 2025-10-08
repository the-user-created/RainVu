import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:in_app_review/in_app_review.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/features/settings/presentation/widgets/app_info_footer.dart";
import "package:rain_wise/features/settings/presentation/widgets/preferences_sheet.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/forms/app_segmented_control.dart";
import "package:share_plus/share_plus.dart";

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
