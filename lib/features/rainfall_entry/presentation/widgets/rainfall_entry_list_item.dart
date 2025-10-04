import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/rainfall_entry/application/rainfall_entry_provider.dart";
import "package:rain_wise/features/rainfall_entry/presentation/widgets/edit_entry_sheet.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rainfall_entry.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/dialogs/app_alert_dialog.dart";

class RainfallEntryListItem extends ConsumerWidget {
  const RainfallEntryListItem({required this.entry, super.key});

  final RainfallEntry entry;

  void _showEditSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final _) => EditEntrySheet(entry: entry),
    );
  }

  Future<void> _deleteEntry(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AppAlertDialog(
        title: l10n.deleteEntryDialogTitle,
        content: Text(l10n.deleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.deleteButtonLabel),
          ),
        ],
      ),
    );

    if (confirmed == true && entry.id != null) {
      await ref.read(rainfallEntryProvider.notifier).deleteEntry(entry.id!);
      showSnackbar(l10n.rainfallEntryDeletedSuccess, type: MessageType.success);
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    final String gaugeName;
    if (entry.gauge != null) {
      if (entry.gauge!.id == AppConstants.defaultGaugeId) {
        gaugeName = l10n.defaultGaugeName;
      } else {
        gaugeName = entry.gauge!.name;
      }
    } else {
      gaugeName = l10n.unknownGauge;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMd().format(entry.date),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${entry.amount.formatRainfall(context, unit)} - $gaugeName",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                AppIconButton(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.secondary,
                    size: 24,
                  ),
                  tooltip: l10n.editEntryTooltip,
                  onPressed: () => _showEditSheet(context),
                ),
                const SizedBox(width: 8),
                AppIconButton(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                    size: 24,
                  ),
                  tooltip: l10n.deleteEntryTooltip,
                  onPressed: () => _deleteEntry(context, ref, l10n),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
