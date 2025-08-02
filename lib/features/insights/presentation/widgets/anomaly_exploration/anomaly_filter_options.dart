import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/insights/application/anomaly_exploration_provider.dart";
import "package:rain_wise/features/insights/domain/anomaly_data.dart";

class AnomalyFilterOptions extends ConsumerWidget {
  const AnomalyFilterOptions({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text("Filter Options", style: textTheme.titleMedium),
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
    final DateTimeRange dateRange = ref
        .watch(anomalyFilterNotifierProvider.select((final f) => f.dateRange));
    final String dateText =
        "${DateFormat.yMd().format(dateRange.start)} - ${DateFormat.yMd().format(dateRange.end)}";

    return InkWell(
      onTap: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          initialDateRange: dateRange,
        );
        if (picked != null) {
          ref.read(anomalyFilterNotifierProvider.notifier).setDateRange(picked);
        }
      },
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
    );
  }
}

class _SeveritySelector extends ConsumerWidget {
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return InkWell(
      onTap: () => _showSeverityDialog(context, ref),
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
              Text("Severity", style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  void _showSeverityDialog(final BuildContext context, final WidgetRef ref) {
    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text("Select Severity Levels"),
        content: SingleChildScrollView(
          child: Consumer(
            builder: (final context, final ref, final _) {
              final Set<AnomalySeverity> selected = ref.watch(
                anomalyFilterNotifierProvider.select((final f) => f.severities),
              );
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: AnomalySeverity.values
                    .map(
                      (final severity) => CheckboxListTile(
                        title: Text(severity.label),
                        value: selected.contains(severity),
                        onChanged: (final _) {
                          ref
                              .read(anomalyFilterNotifierProvider.notifier)
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
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }
}
