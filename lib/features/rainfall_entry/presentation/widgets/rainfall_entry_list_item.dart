import "package:firebase_crashlytics/firebase_crashlytics.dart";
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
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

class RainfallEntryListItem extends ConsumerWidget {
  const RainfallEntryListItem({required this.entry, super.key});

  final RainfallEntry entry;

  void _showEditSheet(final BuildContext context) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final _) => EditEntrySheet(entry: entry),
    );
  }

  Future<void> _showDeleteSheet(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) async {
    final bool? confirmed = await showAdaptiveSheet<bool>(
      context: context,
      builder: (final _) => const _DeleteEntrySheet(),
    );

    if (confirmed == true && entry.id != null) {
      try {
        await ref.read(rainfallEntryProvider.notifier).deleteEntry(entry.id!);
        showSnackbar(
          l10n.rainfallEntryDeletedSuccess,
          type: MessageType.success,
        );
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "Failed to delete rainfall entry",
        );
        showSnackbar(l10n.genericError, type: MessageType.error);
      }
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppIconButton(
                icon: const Icon(Icons.delete_outline, size: 22),
                tooltip: l10n.deleteEntryTooltip,
                onPressed: () => _showDeleteSheet(context, ref, l10n),
                color: colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteEntrySheet extends StatelessWidget {
  const _DeleteEntrySheet();

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InteractiveSheet(
      title: Text(l10n.deleteEntryDialogTitle),
      actions: [
        AppButton(
          label: l10n.deleteButtonLabel,
          onPressed: () => Navigator.of(context).pop(true),
          style: AppButtonStyle.destructive,
        ),
      ],
      child: Text(l10n.deleteDialogContent),
    );
  }
}
