import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:rain_wise/features/settings/application/notifications_providers.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class ReminderTimeTile extends ConsumerWidget {
  const ReminderTimeTile({required this.reminderTime, super.key});

  final TimeOfDay reminderTime;

  Future<void> _showTimePicker(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final NotificationSettingsNotifier settingsNotifier =
        ref.read(notificationSettingsProvider.notifier);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    await showModalBottomSheet<void>(
      context: context,
      builder: (final context) {
        final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(context);
        return Container(
          height: MediaQuery.sizeOf(context).height / 3,
          color: colorScheme.surface,
          child: CupertinoTheme(
            data: cupertinoTheme.copyWith(
              textTheme: cupertinoTheme.textTheme.copyWith(
                dateTimePickerTextStyle: textTheme.headlineMedium,
              ),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime(
                2023,
                1,
                1,
                reminderTime.hour,
                reminderTime.minute,
              ),
              use24hFormat: MediaQuery.of(context).alwaysUse24HourFormat,
              onDateTimeChanged: (final newDateTime) {
                settingsNotifier
                    .setReminderTime(TimeOfDay.fromDateTime(newDateTime));
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return InkWell(
      onTap: () => _showTimePicker(context, ref),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.notificationsReminderTime, style: textTheme.bodyMedium),
            Row(
              children: [
                Icon(Icons.access_time, color: colorScheme.onSurface, size: 20),
                const SizedBox(width: 8),
                Text(
                  reminderTime.format(context),
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
            FaIcon(
              FontAwesomeIcons.chevronDown,
              color: colorScheme.onSurface,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
