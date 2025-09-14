import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/settings/application/notifications_providers.dart";
import "package:rain_wise/features/settings/domain/notification_settings.dart";
import "package:rain_wise/features/settings/presentation/widgets/notifications/notification_setting_tile.dart";
import "package:rain_wise/features/settings/presentation/widgets/notifications/reminder_time_tile.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class DailyReminderSettingsGroup extends ConsumerWidget {
  const DailyReminderSettingsGroup({required this.settings, super.key});

  final NotificationSettings settings;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final NotificationSettingsNotifier notifier =
        ref.read(notificationSettingsProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NotificationSettingTile(
          title: l10n.notificationsDailyReminderTitle,
          subtitle: l10n.notificationsDailyReminderSubtitle,
          value: settings.dailyReminder,
          onChanged: notifier.setDailyReminder,
        ),
        if (settings.dailyReminder)
          ReminderTimeTile(reminderTime: settings.reminderTime),
      ],
    );
  }
}
