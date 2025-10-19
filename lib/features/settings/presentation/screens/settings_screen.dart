import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/application/app_store_service.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/firebase/telemetry_manager.dart";
import "package:rainvu/core/navigation/app_router.dart";
import "package:rainvu/core/utils/snackbar_service.dart";
import "package:rainvu/features/settings/application/app_reset_provider.dart";
import "package:rainvu/features/settings/presentation/widgets/app_info_footer.dart";
import "package:rainvu/features/settings/presentation/widgets/danger_zone_card.dart";
import "package:rainvu/features/settings/presentation/widgets/preferences_sheet.dart";
import "package:rainvu/features/settings/presentation/widgets/settings_card.dart";
import "package:rainvu/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rainvu/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:rainvu/shared/utils/adaptive_ui_helpers.dart";
import "package:rainvu/shared/utils/ui_helpers.dart";
import "package:rainvu/shared/widgets/buttons/app_button.dart";
import "package:rainvu/shared/widgets/forms/app_segmented_control.dart";
import "package:rainvu/shared/widgets/sheets/interactive_sheet.dart";

/// The main settings screen, composed of smaller, reusable widgets.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showPreferencesSheet(final BuildContext context) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final _) => const PreferencesSheet(),
    );
  }

  /// Handles the "Leave a Review" action by opening the app's store page.
  Future<void> _leaveReview(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    try {
      await ref.read(appStoreServiceProvider).openStoreListingForReview();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Open store listing failed",
      );
      if (context.mounted) {
        showSnackbar(l10n.reviewNotAvailable, type: MessageType.error);
      }
    }
  }

  /// Handles the "Share RainVu" action using the central AppStoreService.
  Future<void> _shareApp(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(appStoreServiceProvider)
          .shareApp(
            context: context,
            text: l10n.shareAppText,
            subject: l10n.shareAppSubject,
          );
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Share app action failed",
      );
      if (context.mounted) {
        showSnackbar(l10n.shareError, type: MessageType.error);
      }
    }
  }

  Future<void> _showResetConfirmationSheet(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final bool? confirmed = await showAdaptiveSheet<bool>(
      context: context,
      builder: (final _) => const _ResetSheet(),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(appResetServiceProvider.notifier).resetApp();

        ref.invalidate(userPreferencesProvider);

        if (context.mounted) {
          showSnackbar(l10n.resetSuccessSnackbar, type: MessageType.success);
        }
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "App reset failed from settings screen",
        );
        if (context.mounted) {
          showSnackbar(l10n.resetErrorSnackbar, type: MessageType.error);
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
        automaticallyImplyLeading: false,
        title: Text(l10n.settingsTitle, style: theme.textTheme.headlineLarge),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SettingsSectionHeader(title: l10n.settingsSectionAppearance),
            const SettingsCard(children: [_ThemeSetting()]),
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
                  onTap: () => _leaveReview(context, ref),
                ),
                Builder(
                  builder: (final builderContext) => SettingsListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: l10n.settingsSupportDevelopmentShareApp,
                    onTap: () => _shareApp(builderContext, ref),
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
                  onTap: () => const PrivacyPolicyRoute().push(context),
                ),
                SettingsListTile(
                  leading: const Icon(Icons.gavel_rounded),
                  title: l10n.settingsSupportLegalTermsOfService,
                  onTap: () => const TermsOfServiceRoute().push(context),
                ),
                SettingsListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: l10n.settingsSupportLegalOssLicenses,
                  onTap: () => const OssLicensesRoute().push(context),
                ),
              ],
            ),
            SettingsSectionHeader(title: l10n.settingsSectionPrivacy),
            const SettingsCard(children: [_TelemetrySetting()]),
            SettingsSectionHeader(title: l10n.settingsSectionDangerZone),
            DangerZoneCard(
              onReset: () => _showResetConfirmationSheet(context, ref),
            ),
            const AppInfoFooter(),
          ],
        ),
      ),
    );
  }
}

class _ThemeSetting extends ConsumerWidget {
  const _ThemeSetting();

  List<SegmentOption<AppThemeMode>> _buildTextSegments(
    final AppLocalizations l10n,
  ) => [
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
  ];

  List<SegmentOption<AppThemeMode>> _buildIconSegments(
    final AppLocalizations l10n,
  ) => [
    SegmentOption(
      value: AppThemeMode.light,
      label: Tooltip(
        message: l10n.settingsThemeLight,
        child: const Icon(Icons.light_mode_outlined, size: 20),
      ),
    ),
    SegmentOption(
      value: AppThemeMode.dark,
      label: Tooltip(
        message: l10n.settingsThemeDark,
        child: const Icon(Icons.dark_mode_outlined, size: 20),
      ),
    ),
    SegmentOption(
      value: AppThemeMode.system,
      label: Tooltip(
        message: l10n.settingsThemeSystem,
        child: const Icon(Icons.settings, size: 20),
      ),
    ),
  ];

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
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

        final Widget control = LayoutBuilder(
          builder: (final context, final constraints) {
            final List<SegmentOption<AppThemeMode>> segments =
                constraints.maxWidth < 290
                ? _buildIconSegments(l10n)
                : _buildTextSegments(l10n);

            return AppSegmentedControl<AppThemeMode>(
              selectedValue: preferences.themeMode,
              onSelectionChanged: (final value) {
                ref.read(userPreferencesProvider.notifier).setThemeMode(value);
              },
              segments: segments,
            );
          },
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
                  children: [
                    Expanded(flex: 2, child: label),
                    const SizedBox(width: 16),
                    Expanded(flex: 3, child: control),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [label, const SizedBox(height: 12), control],
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _TelemetrySetting extends ConsumerWidget {
  const _TelemetrySetting();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<bool> telemetryEnabledAsync = ref.watch(
      telemetryManagerProvider,
    );

    return telemetryEnabledAsync.when(
      loading: () => SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: IconTheme(
          data: IconThemeData(
            color: theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          child: const Icon(Icons.analytics_outlined),
        ),
        title: Text(l10n.settingsTelemetryTitle),
        subtitle: Text(l10n.settingsTelemetryDescription),
        value: true,
        onChanged: null,
      ),
      error: (final e, final s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "Failed to load telemetry setting UI",
        );
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: IconTheme(
            data: IconThemeData(color: theme.colorScheme.error, size: 24),
            child: const Icon(Icons.error_outline),
          ),
          title: Text(l10n.genericError),
          subtitle: Text(l10n.settingsTelemetryDescription),
        );
      },
      data: (final isEnabled) => SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: IconTheme(
          data: IconThemeData(
            color: theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          child: const Icon(Icons.analytics_outlined),
        ),
        title: Text(l10n.settingsTelemetryTitle),
        subtitle: Text(l10n.settingsTelemetryDescription),
        value: isEnabled,
        onChanged: (final value) {
          ref
              .read(telemetryManagerProvider.notifier)
              .setTelemetryEnabled(value);
        },
      ),
    );
  }
}

class _ResetSheet extends StatefulWidget {
  const _ResetSheet();

  @override
  State<_ResetSheet> createState() => _ResetSheetState();
}

class _ResetSheetState extends State<_ResetSheet> {
  final _confirmationController = TextEditingController();
  bool _isButtonEnabled = false;
  late String _confirmationText;

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

    return InteractiveSheet(
      title: Text(l10n.resetDialogTitle),
      actions: <Widget>[
        AppButton(
          style: AppButtonStyle.destructive,
          onPressed: _isButtonEnabled
              ? () => Navigator.of(context).pop(true)
              : null,
          label: l10n.resetDialogConfirmButton,
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(l10n.resetDialogContent(_confirmationText)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmationController,
            decoration: InputDecoration(
              hintText: l10n.resetDialogTextFieldHint(_confirmationText),
            ),
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (final value) {
              if (value == null || value.isEmpty) {
                return l10n.resetDialogValidationEmpty;
              }
              if (value != _confirmationText) {
                return l10n.resetDialogValidationError(_confirmationText);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
