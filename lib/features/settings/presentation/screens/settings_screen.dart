import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/common/domain/coming_soon_args.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/features/settings/presentation/widgets/app_info_footer.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";

/// The main settings screen, composed of smaller, reusable widgets.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.settingsTitle, style: theme.textTheme.headlineLarge),
        elevation: 2,
        centerTitle: false,
      ),
      body: ListView(
        children: [
          SettingsSectionHeader(title: l10n.settingsSectionAccount),
          SettingsCard(
            children: [
              SettingsListTile(
                title: l10n.settingsAccountMySubscription,
                onTap: () => const MySubscriptionRoute().push(context),
              ),
            ],
          ),
          SettingsSectionHeader(title: l10n.settingsSectionDataManagement),
          SettingsCard(
            children: [
              SettingsListTile(
                title: l10n.settingsDataManagementExportImport,
                onTap: () => const DataToolsRoute().push(context),
              ),
              SettingsListTile(
                title: l10n.settingsDataManagementManageGauges,
                onTap: () => const ManageGaugesRoute().push(context),
              ),
              SettingsListTile(
                title: l10n.settingsDataManagementNotifications,
                onTap: () => const NotificationsRoute().push(context),
              ),
            ],
          ),
          SettingsSectionHeader(title: l10n.settingsSectionSupportLegal),
          SettingsCard(
            children: [
              SettingsListTile(
                title: l10n.settingsSupportLegalHelp,
                onTap: () => const HelpRoute().push(context),
              ),
              SettingsListTile(
                title: l10n.settingsSupportLegalPrivacyPolicy,
                onTap: () => const ComingSoonRoute(
                  $extra: ComingSoonScreenArgs(
                    pageTitle: "Privacy Policy",
                  ),
                ).push(context),
              ),
              SettingsListTile(
                title: l10n.settingsSupportLegalTermsOfService,
                onTap: () => const ComingSoonRoute(
                  $extra: ComingSoonScreenArgs(
                    pageTitle: "Terms of Service",
                  ),
                ).push(context),
              ),
            ],
          ),
          // TODO: Add logout/login functionality
          const AppInfoFooter(),
        ],
      ),
    );
  }
}
