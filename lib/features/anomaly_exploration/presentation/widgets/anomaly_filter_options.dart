import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/data/providers/data_providers.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/features/anomaly_exploration/application/anomaly_exploration_provider.dart";
import "package:rain_wise/features/anomaly_exploration/domain/anomaly_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/pickers/date_range_picker.dart";

class AnomalyFilterOptions extends ConsumerWidget {
  const AnomalyFilterOptions({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: theme.shadowColor,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(l10n.filterOptionsTitle, style: textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _DateRangePicker()),
              const SizedBox(width: 12),
              Expanded(child: _SeveritySelector()),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateRangePicker extends ConsumerWidget {
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final DateTimeRange dateRange = ref.watch(
      anomalyFilterProvider.select((final f) => f.dateRange),
    );
    final String dateText =
        "${DateFormat.yMd().format(dateRange.start)} - ${DateFormat.yMd().format(dateRange.end)}";
    final AsyncValue<DateRangeResult> dbDateRangeAsync = ref.watch(
      rainfallDateRangeProvider,
    );

    final bool hasData = dbDateRangeAsync.maybeWhen(
      data: (final data) => data.min != null && data.max != null,
      orElse: () => false,
    );

    return Opacity(
      opacity: hasData ? 1.0 : 0.5,
      child: InkWell(
        onTap: hasData
            ? () async {
                final DateRangeResult dbDateRange = dbDateRangeAsync.value!;
                final DateTimeRange? picked = await showDateRangePickerModal(
                  context,
                  firstDate: dbDateRange.min!,
                  lastDate: dbDateRange.max!,
                  initialDateRange: dateRange,
                );
                if (picked != null) {
                  ref.read(anomalyFilterProvider.notifier).setDateRange(picked);
                }
              }
            : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dateText,
                    style: textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SeveritySelector extends ConsumerWidget {
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: () => _showSeverityDialog(context, ref, l10n),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.warning, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(l10n.severityFilterLabel, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  void _showSeverityDialog(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: Text(l10n.selectSeverityLevelsDialogTitle),
        content: SingleChildScrollView(
          child: Consumer(
            builder: (final context, final ref, final _) {
              final Set<AnomalySeverity> selected = ref.watch(
                anomalyFilterProvider.select((final f) => f.severities),
              );
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: AnomalySeverity.values
                    .map(
                      (final severity) => CheckboxListTile(
                        title: Text(severity.getLabel(l10n)),
                        value: selected.contains(severity),
                        onChanged: (final _) {
                          ref
                              .read(anomalyFilterProvider.notifier)
                              .toggleSeverity(severity);
                        },
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.doneButtonLabel),
          ),
        ],
      ),
    );
  }
}
