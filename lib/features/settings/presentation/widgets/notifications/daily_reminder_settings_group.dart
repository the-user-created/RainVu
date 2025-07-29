import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/settings/application/notifications_providers.dart";
import "package:rain_wise/features/settings/domain/notification_settings.dart";
import "package:rain_wise/features/settings/presentation/widgets/notifications/notification_setting_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/notifications/reminder_time_tile.dart";

class DailyReminderSettingsGroup extends ConsumerWidget {
  const DailyReminderSettingsGroup({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final NotificationSettings settings = ref.watch(notificationSettingsNotifierProvider);
    final NotificationSettingsNotifier notifier = ref.read(notificationSettingsNotifierProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NotificationSettingTile(
          title: "Daily Reminder",
          subtitle: "Get reminded to log your rainfall data",
          value: settings.dailyReminder,
          onChanged: notifier.setDailyReminder,
        ),
        if (settings.dailyReminder) const ReminderTimeTile(),
      ],
    );
  }
}
