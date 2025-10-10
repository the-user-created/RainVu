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
import "package:rain_wise/shared/utils/adaptive_ui_helpers.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/dialogs/app_alert_dialog.dart";

class RainfallEntryListItem extends ConsumerWidget {
  const RainfallEntryListItem({required this.entry, super.key});

  final RainfallEntry entry;

  void _showEditSheet(final BuildContext context) {
    showAdaptiveSheet<void>(
      context: context,
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
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
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
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showEditSheet(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              entry.amount.formatRainfall(
                                context,
                                unit,
                                withUnit: false,
                              ),
                              style: textTheme.headlineSmall?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text(
                                unit.name,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat.jm().format(entry.date),
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gaugeName,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.8,
                        ),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppIconButton(
                icon: const Icon(Icons.delete_outline, size: 22),
                tooltip: l10n.deleteEntryTooltip,
                onPressed: () => _deleteEntry(context, ref, l10n),
                color: colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
