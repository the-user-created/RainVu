import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rainvu/core/data/providers/data_providers.dart";
import "package:rainvu/core/data/repositories/rainfall_repository.dart";
import "package:rainvu/features/unusual_patterns/application/unusual_patterns_provider.dart";
import "package:rainvu/features/unusual_patterns/domain/unusual_patterns_data.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/utils/adaptive_ui_helpers.dart";
import "package:rainvu/shared/widgets/buttons/app_button.dart";
import "package:rainvu/shared/widgets/gauge_filter_dropdown.dart";
import "package:rainvu/shared/widgets/pickers/date_range_picker.dart";
import "package:rainvu/shared/widgets/sheets/interactive_sheet.dart";

class UnusualPatternsFilters extends ConsumerWidget {
  const UnusualPatternsFilters({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AsyncValue<AnomalyFilter> filterAsync = ref.watch(
      anomalyFilterProvider,
    );
    final AnomalyFilter? filter = filterAsync.value;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        const GaugeFilterDropdown(),
        _DateRangePickerButton(dateRange: filter?.dateRange),
        _SeveritySelectorButton(severities: filter?.severities),
      ],
    );
  }
}

class _DateRangePickerButton extends ConsumerWidget {
  const _DateRangePickerButton({this.dateRange});

  final DateTimeRange? dateRange;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final DateTimeRange? dateRange = this.dateRange;

    final String dateText;
    final String? semanticDateText;

    if (dateRange != null) {
      final String startDate = DateFormat.yMd().format(dateRange.start);
      final String endDate = DateFormat.yMd().format(dateRange.end);
      dateText = "$startDate - $endDate";
      semanticDateText = l10n.dateRangeSemanticsLabel(startDate, endDate);
    } else {
      dateText = "Loading...";
      semanticDateText = dateText;
    }

    final AsyncValue<DateRangeResult> dbDateRangeAsync = ref.watch(
      rainfallDateRangeProvider,
    );

    final bool canPress =
        dateRange != null &&
        dbDateRangeAsync.maybeWhen(
          data: (final data) => data.min != null && data.max != null,
          orElse: () => false,
        );

    return AppButton(
      onPressed: canPress
          ? () async {
              final DateRangeResult dbDateRange = dbDateRangeAsync.value!;
              final DateTimeRange? picked = await showAppDateRangePicker(
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
      label: dateText,
      semanticLabel: semanticDateText,
      style: AppButtonStyle.secondary,
      size: AppButtonSize.small,
      icon: const Icon(Icons.calendar_today, size: 20),
    );
  }
}

class _SeveritySelectorButton extends ConsumerWidget {
  const _SeveritySelectorButton({this.severities});

  final Set<AnomalySeverity>? severities;

  String _buildSelectionText(
    final Set<AnomalySeverity>? selected,
    final AppLocalizations l10n,
  ) {
    if (selected == null) {
      return "Loading...";
    }
    final int count = selected.length;
    if (count == 0) {
      return l10n.selectSeverityHint;
    }
    if (count == AnomalySeverity.values.length) {
      return l10n.allSeverities;
    }
    if (count <= 2) {
      return selected.map((final s) => s.getLabel(l10n)).join(", ");
    }
    return l10n.severitiesSelected(count);
  }

  void _showSeveritySheet(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final _) => const _SeveritySelectionSheet(),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Set<AnomalySeverity>? severities = this.severities;

    return AppButton(
      onPressed: severities != null
          ? () => _showSeveritySheet(context, ref, l10n)
          : null,
      label: _buildSelectionText(severities, l10n),
      style: AppButtonStyle.secondary,
      size: AppButtonSize.small,
      icon: const Icon(Icons.warning_amber_rounded, size: 20),
    );
  }
}

class _SeveritySelectionSheet extends ConsumerWidget {
  const _SeveritySelectionSheet();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InteractiveSheet(
      title: Text(l10n.selectSeverityLevelsDialogTitle),
      actions: [
        AppButton(
          label: l10n.doneButtonLabel,
          onPressed: () => Navigator.of(context).pop(),
          style: AppButtonStyle.secondary,
        ),
      ],
      child: Consumer(
        builder: (final context, final ref, final _) {
          final Set<AnomalySeverity> selected = ref.watch(
            anomalyFilterProvider.select(
              (final asyncValue) => asyncValue.value?.severities ?? {},
            ),
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
    );
  }
}
