import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/common/domain/coming_soon_args.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";
import "package:rain_wise/features/settings/presentation/widgets/app_info_footer.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_list_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

/// The main settings screen, composed of smaller, reusable widgets.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        automaticallyImplyLeading: false,
        title: Text("Settings", style: theme.headlineLarge),
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
                onTap: () =>
                    context.pushNamed(AppRouteNames.mySubscriptionName),
              ),
            ],
          ),
          const SettingsSectionHeader(title: "DATA MANAGEMENT"),
          SettingsCard(
            children: [
              SettingsListTile(
                title: "Data Export/Import",
                onTap: () => context.pushNamed(AppRouteNames.dataToolsName),
              ),
              SettingsListTile(
                title: "Manage Rain Gauges",
                onTap: () => context.pushNamed(AppRouteNames.manageGaugesName),
              ),
              SettingsListTile(
                title: "Notifications",
                onTap: () => context.pushNamed(AppRouteNames.notificationsName),
              ),
            ],
          ),
          const SettingsSectionHeader(title: "SUPPORT & LEGAL"),
          SettingsCard(
            children: [
              SettingsListTile(
                title: "Help & Support",
                onTap: () => context.pushNamed(AppRouteNames.helpName),
              ),
              SettingsListTile(
                title: "Privacy Policy",
                onTap: () => context.pushNamed(
                  AppRouteNames.comingSoonName,
                  extra:
                      const ComingSoonScreenArgs(pageTitle: "Privacy Policy"),
                ),
              ),
              SettingsListTile(
                title: "Terms of Service",
                onTap: () => context.pushNamed(
                  AppRouteNames.comingSoonName,
                  extra:
                      const ComingSoonScreenArgs(pageTitle: "Terms of Service"),
                ),
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
