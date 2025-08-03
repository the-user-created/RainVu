import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/common/domain/coming_soon_args.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/features/settings/presentation/widgets/app_info_footer.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";

/// The main settings screen, composed of smaller, reusable widgets.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Settings", style: theme.textTheme.headlineLarge),
        elevation: 2,
        centerTitle: false,
      ),
      body: ListView(
        children: [
          const SettingsSectionHeader(title: "ACCOUNT"),
          SettingsCard(
            children: [
              SettingsListTile(
                title: "My Subscription",
                onTap: () => const MySubscriptionRoute().push(context),
              ),
            ],
          ),
          const SettingsSectionHeader(title: "DATA MANAGEMENT"),
          SettingsCard(
            children: [
              SettingsListTile(
                title: "Data Export/Import",
                onTap: () => const DataToolsRoute().push(context),
              ),
              SettingsListTile(
                title: "Manage Rain Gauges",
                onTap: () => const ManageGaugesRoute().push(context),
              ),
              SettingsListTile(
                title: "Notifications",
                onTap: () => const NotificationsRoute().push(context),
              ),
            ],
          ),
          const SettingsSectionHeader(title: "SUPPORT & LEGAL"),
          SettingsCard(
            children: [
              SettingsListTile(
                title: "Help & Support",
                onTap: () => const HelpRoute().push(context),
              ),
              SettingsListTile(
                title: "Privacy Policy",
                onTap: () => const ComingSoonRoute(
                  $extra: ComingSoonScreenArgs(
                    pageTitle: "Privacy Policy",
                  ),
                ).push(context),
              ),
              SettingsListTile(
                title: "Terms of Service",
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
