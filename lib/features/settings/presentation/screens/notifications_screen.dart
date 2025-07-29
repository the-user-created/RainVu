import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/settings/application/notifications_providers.dart";
import "package:rain_wise/features/settings/domain/notification_settings.dart";
import "package:rain_wise/features/settings/presentation/widgets/notifications/daily_reminder_settings_group.dart";
import "package:rain_wise/features/settings/presentation/widgets/notifications/notification_setting_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final NotificationSettings settings =
        ref.watch(notificationSettingsNotifierProvider);
    final NotificationSettingsNotifier notifier =
        ref.read(notificationSettingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        iconTheme: IconThemeData(color: theme.primaryText),
        title: Text("Notifications", style: theme.headlineMedium),
        centerTitle: false,
        elevation: 2,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            const SettingsSectionHeader(title: "DAILY LOGGING"),
            const SettingsCard(
              children: [
                DailyReminderSettingsGroup(),
              ],
            ),
            const SettingsSectionHeader(title: "REPORTS & ALERTS"),
            SettingsCard(
              children: [
                NotificationSettingTile(
                  title: "Weekly Summary Report",
                  subtitle: "Receive weekly rainfall data overview",
                  value: settings.weeklySummary,
                  onChanged: notifier.setWeeklySummary,
                ),
                NotificationSettingTile(
                  title: "Weather Alerts",
                  subtitle: "Get notified about severe weather conditions",
                  value: settings.weatherAlerts,
                  onChanged: notifier.setWeatherAlerts,
                ),
              ],
            ),
            const SettingsSectionHeader(title: "GENERAL"),
            SettingsCard(
              children: [
                NotificationSettingTile(
                  title: "App Updates",
                  subtitle: "Stay informed about new features",
                  value: settings.appUpdates,
                  onChanged: notifier.setAppUpdates,
                ),
              ],
            ),
            // TODO: Add a way to see all past notifications
            // TODO: Implement notifications on Firebase
          ],
        ),
      ),
    );
  }
}
