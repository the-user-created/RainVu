import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/data/providers/data_providers.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/data_tools/application/data_tools_provider.dart";
import "package:rain_wise/features/data_tools/domain/data_tools_state.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/forms/app_choice_chips.dart";
import "package:rain_wise/shared/widgets/pickers/date_range_picker.dart";

class ExportDataCard extends ConsumerWidget {
  const ExportDataCard({super.key});

  String _getFormatLabel(
    final BuildContext context,
    final ExportFormat format,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    switch (format) {
      case ExportFormat.csv:
        return l10n.exportFormatCsv;
      case ExportFormat.json:
        return l10n.exportFormatJson;
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final DataToolsState state = ref.watch(dataToolsProvider);
    final DataToolsNotifier notifier = ref.read(dataToolsProvider.notifier);
    final AsyncValue<DateRangeResult> dateRangeAsync = ref.watch(
      rainfallDateRangeProvider,
    );

    return SettingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.exportDataCardTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.exportDataCardDescription,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              _DateRangePickerTile(
                dateRange: state.dateRange,
                onTap: dateRangeAsync.when(
                  data: (final data) => () async {
                    if (data.min == null || data.max == null) {
                      showSnackbar(
                        l10n.noDataToSetDateRange,
                        type: MessageType.error,
                      );
                      return;
                    }

                    final DateTimeRange defaultRange = DateTimeRange(
                      start: data.min!,
                      end: data.max!,
                    );
                    final DateTimeRange? newRange =
                        await showAppDateRangePicker(
                          context,
                          firstDate: data.min!,
                          lastDate: data.max!,
                          initialDateRange: state.dateRange ?? defaultRange,
                        );
                    if (newRange != null) {
                      notifier.setDateRange(newRange);
                    }
                  },
                  loading: () => null,
                  error: (final _, final _) => null,
                ),
                onClear: () => notifier.setDateRange(null),
              ),
              const SizedBox(height: 16),
              Text(l10n.exportFormatTitle, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              AppChoiceChips<ExportFormat>(
                selectedValue: state.exportFormat,
                onSelected: notifier.setExportFormat,
                options: ExportFormat.values
                    .map(
                      (final format) => ChipOption(
                        value: format,
                        label: _getFormatLabel(context, format),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              AppButton(
                onPressed: state.isExporting
                    ? null
                    : () => notifier.exportData(l10n),
                label: l10n.downloadFileButtonLabel,
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
  const _DateRangePickerTile({
    required this.onTap,
    this.dateRange,
    this.onClear,
  });

  final DateTimeRange? dateRange;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String label;

    if (dateRange == null) {
      label = l10n.dateRangeAllTime;
    } else {
      final DateFormat formatter = DateFormat.yMd();
      label =
          "${formatter.format(dateRange!.start)} - ${formatter.format(dateRange!.end)}";
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            if (dateRange != null && onClear != null)
              AppIconButton(
                icon: const Icon(Icons.close),
                onPressed: onClear,
                tooltip: l10n.clearSelectionTooltip,
                padding: const EdgeInsets.all(4),
                iconSize: 20,
              )
            else
              const Icon(Icons.calendar_today, size: 24),
          ],
        ),
      ),
    );
  }
}
