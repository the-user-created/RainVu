import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/data_tools/application/data_tools_provider.dart";
import "package:rain_wise/features/data_tools/domain/data_tools_state.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/forms/app_choice_chips.dart";

class ExportDataCard extends ConsumerWidget {
  const ExportDataCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final DataToolsState state = ref.watch(dataToolsNotifierProvider);
    final DataToolsNotifier notifier =
        ref.read(dataToolsNotifierProvider.notifier);

    return SettingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Export Your Data",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                "Select date range and format to export your rainfall data",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              _DateRangePickerTile(
                dateRange: state.dateRange,
                onTap: () async {
                  final DateTimeRange? newRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    currentDate: DateTime.now(),
                    initialDateRange: state.dateRange,
                  );
                  // setDateRange can be null-aware
                  if (newRange != null) {
                    notifier.setDateRange(newRange);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text("Export Format", style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              AppChoiceChips<ExportFormat>(
                selectedValue: state.exportFormat,
                onSelected: notifier.setExportFormat,
                options: ExportFormat.values
                    .map(
                      (final format) => ChipOption(
                        value: format,
                        label: format.name.toUpperCase(),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              AppButton(
                onPressed: state.isExporting ? null : notifier.exportData,
                label: "Download File",
                isLoading: state.isExporting,
                isExpanded: true,
                icon: Icon(
                  Icons.download,
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateRangePickerTile extends StatelessWidget {
  const _DateRangePickerTile({required this.onTap, this.dateRange});

  final DateTimeRange? dateRange;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String label;

    if (dateRange == null) {
      label = "Date Range: All Time";
    } else {
      final DateFormat formatter = DateFormat.yMd();
      label =
          "${formatter.format(dateRange!.start)} - ${formatter.format(dateRange!.end)}";
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            Icon(
              Icons.calendar_today,
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
