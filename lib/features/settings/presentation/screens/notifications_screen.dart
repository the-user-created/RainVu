import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/settings/application/notifications_providers.dart";
import "package:rain_wise/features/settings/domain/notification_settings.dart";
import "package:rain_wise/features/settings/presentation/widgets/notifications/daily_reminder_settings_group.dart";
import "package:rain_wise/features/settings/presentation/widgets/notifications/notification_setting_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final NotificationSettings settings =
        ref.watch(notificationSettingsNotifierProvider);
    final NotificationSettingsNotifier notifier =
        ref.read(notificationSettingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        centerTitle: false,
        elevation: 2,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            SettingsSectionHeader(title: l10n.notificationsSectionDailyLogging),
            const SettingsCard(
              children: [
                DailyReminderSettingsGroup(),
              ],
            ),
            SettingsSectionHeader(
              title: l10n.notificationsSectionReportsAlerts,
            ),
            SettingsCard(
              children: [
                NotificationSettingTile(
                  title: l10n.notificationsWeeklySummaryTitle,
                  subtitle: l10n.notificationsWeeklySummarySubtitle,
                  value: settings.weeklySummary,
                  onChanged: notifier.setWeeklySummary,
                ),
                NotificationSettingTile(
                  title: l10n.notificationsWeatherAlertsTitle,
                  subtitle: l10n.notificationsWeatherAlertsSubtitle,
                  value: settings.weatherAlerts,
                  onChanged: notifier.setWeatherAlerts,
                ),
              ],
            ),
            SettingsSectionHeader(title: l10n.notificationsSectionGeneral),
            SettingsCard(
              children: [
                NotificationSettingTile(
                  title: l10n.notificationsAppUpdatesTitle,
                  subtitle: l10n.notificationsAppUpdatesSubtitle,
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
