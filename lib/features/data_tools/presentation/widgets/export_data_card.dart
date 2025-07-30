import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/data_tools/application/data_tools_provider.dart";
import "package:rain_wise/features/data_tools/domain/data_tools_state.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class ExportDataCard extends ConsumerWidget {
  const ExportDataCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
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
                style: theme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                "Select date range and format to export your rainfall data",
                textAlign: TextAlign.center,
                style: theme.bodyMedium.copyWith(color: theme.secondaryText),
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
                  notifier.setDateRange(newRange);
                },
              ),
              const SizedBox(height: 16),
              Text("Export Format", style: theme.bodyMedium),
              const SizedBox(height: 8),
              _FormatSelectorChips(
                selectedFormat: state.exportFormat,
                onFormatSelected: notifier.setExportFormat,
              ),
              const SizedBox(height: 24),
              AppButton(
                onPressed: state.isExporting ? null : notifier.exportData,
                label: "Download File",
                isLoading: state.isExporting,
                isExpanded: true,
                icon: Icon(
                  Icons.download,
                  color: theme.secondaryBackground,
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
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
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
          color: theme.alternate,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.bodyMedium),
            Icon(Icons.calendar_today, color: theme.primaryText, size: 24),
          ],
        ),
      ),
    );
  }
}

class _FormatSelectorChips extends StatelessWidget {
  const _FormatSelectorChips({
    required this.selectedFormat,
    required this.onFormatSelected,
  });

  final ExportFormat selectedFormat;
  final ValueChanged<ExportFormat> onFormatSelected;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Wrap(
      spacing: 8,
      children: ExportFormat.values.map((final format) {
        final bool isSelected = selectedFormat == format;
        return ChoiceChip(
          label: Text(format.name.toUpperCase()),
          selected: isSelected,
          onSelected: (final _) => onFormatSelected(format),
          labelStyle: isSelected
              ? theme.bodyMedium.copyWith(color: theme.secondaryBackground)
              : theme.bodyMedium,
          selectedColor: theme.primary,
          backgroundColor: theme.alternate,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }
}
