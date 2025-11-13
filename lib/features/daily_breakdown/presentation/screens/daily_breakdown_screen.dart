import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rainvu/app_constants.dart";
import "package:rainvu/core/data/providers/data_providers.dart";
import "package:rainvu/core/data/repositories/rainfall_repository.dart";
import "package:rainvu/core/utils/snackbar_service.dart";
import "package:rainvu/features/daily_breakdown/application/daily_breakdown_provider.dart";
import "package:rainvu/features/daily_breakdown/domain/daily_breakdown_data.dart";
import "package:rainvu/features/daily_breakdown/presentation/widgets/daily_rainfall_chart.dart";
import "package:rainvu/features/daily_breakdown/presentation/widgets/monthly_summary_card.dart";
import "package:rainvu/features/daily_breakdown/presentation/widgets/past_averages_card.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/utils/ui_helpers.dart";
import "package:rainvu/shared/widgets/buttons/app_button.dart";
import "package:rainvu/shared/widgets/buttons/app_icon_button.dart";
import "package:rainvu/shared/widgets/filter_bar.dart";
import "package:rainvu/shared/widgets/gauge_filter_dropdown.dart";
import "package:rainvu/shared/widgets/pickers/month_year_picker.dart";
import "package:rainvu/shared/widgets/placeholders.dart";
import "package:rainvu/shared/widgets/sheets/info_sheet.dart";
import "package:shimmer/shimmer.dart";

class DailyBreakdownScreen extends ConsumerStatefulWidget {
  const DailyBreakdownScreen({this.initialMonth, super.key});

  /// An optional initial month to display, in 'YYYY-MM' format.
  final String? initialMonth;

  @override
  ConsumerState<DailyBreakdownScreen> createState() =>
      _DailyBreakdownScreenState();
}

class _DailyBreakdownScreenState extends ConsumerState<DailyBreakdownScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    if (widget.initialMonth != null) {
      try {
        final List<String> parts = widget.initialMonth!.split("-");
        if (parts.length == 2) {
          final int? year = int.tryParse(parts[0]);
          final int? month = int.tryParse(parts[1]);
          if (year != null && month != null) {
            _selectedMonth = DateTime(year, month);
            return; // Exit if successful
          }
        }
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "Failed to parse initialMonth in DailyBreakdownScreen",
          information: ["initialMonth: ${widget.initialMonth}"],
        );
      }
    }
    // Fallback to the current month if no valid initialMonth is provided.
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _showInfoSheet(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    InfoSheet.show(
      context,
      title: l10n.dailyBreakdownInfoSheetTitle,
      items: [
        InfoSheetItem(
          icon: Icons.functions,
          title: l10n.dailyBreakdownInfoSumTitle,
          description: l10n.dailyBreakdownInfoSumDescription,
        ),
        InfoSheetItem(
          icon: Icons.pie_chart_outline,
          title: l10n.dailyBreakdownInfoAverageTitle,
          description: l10n.dailyBreakdownInfoAverageDescription,
        ),
      ],
    );
  }

  Future<void> _pickMonth() async {
    final DateRangeResult? dateRange = ref
        .read(rainfallDateRangeProvider)
        .value;
    // Defensive check: ensure date range data is loaded before proceeding.
    if (dateRange?.min == null || dateRange?.max == null) {
      showSnackbar(
        AppLocalizations.of(context).genericError,
        type: MessageType.error,
      );
      return;
    }

    final DateTime? picked = await showMonthYearPicker(
      context,
      initialDate: _selectedMonth,
      firstDate: dateRange!.min!,
      lastDate: dateRange.max!,
    );
    if (picked != null &&
        (picked.year != _selectedMonth.year ||
            picked.month != _selectedMonth.month)) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<DailyBreakdownData> breakdownDataAsync = ref.watch(
      dailyBreakdownProvider(_selectedMonth),
    );
    final AsyncValue<DateRangeResult> dateRangeAsync = ref.watch(
      rainfallDateRangeProvider,
    );

    final VoidCallback? onPickMonthCallback = dateRangeAsync.when(
      data: (final data) =>
          (data.min != null && data.max != null) ? _pickMonth : null,
      loading: () => null,
      error: (final _, final _) => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.dailyBreakdownTitle,
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppIconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showInfoSheet(context),
              tooltip: l10n.infoTooltip,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            FilterBar(
              child: _DailyBreakdownFilters(
                selectedMonth: _selectedMonth,
                onPickMonth: onPickMonthCallback,
              ),
            ),
            Expanded(
              child: breakdownDataAsync.when(
                loading: () => const _LoadingState(),
                error: (final err, final stack) {
                  FirebaseCrashlytics.instance.recordError(
                    err,
                    stack,
                    reason: "Failed to load daily breakdown data",
                  );
                  return Center(
                    child: Text(
                      l10n.dailyBreakdownError,
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                },
                data: (final data) {
                  if (data.summaryStats.totalRainfall == 0) {
                    return const _EmptyState();
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        MonthlySummaryCard(
                          stats: data.summaryStats,
                          selectedMonth: _selectedMonth,
                        ),
                        const SizedBox(height: 24),
                        PastAveragesCard(
                          stats: data.historicalStats,
                          currentTotal: data.summaryStats.totalRainfall,
                        ),
                        const SizedBox(height: 24),
                        DailyRainfallChart(
                          chartData: data.dailyChartData,
                          selectedMonth: _selectedMonth,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A responsive widget for the filter controls in the [DailyBreakdownScreen].
///
/// It displays the filter controls in a `Row` on wider screens and switches
/// to a `Column` on narrower screens to prevent overflow.
class _DailyBreakdownFilters extends StatelessWidget {
  const _DailyBreakdownFilters({required this.selectedMonth, this.onPickMonth});

  final DateTime selectedMonth;
  final VoidCallback? onPickMonth;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
    builder: (final context, final constraints) {
      const double breakpoint = 380;

      if (constraints.maxWidth < breakpoint) {
        // Vertical layout for smaller screens or larger fonts
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GaugeFilterDropdown(),
            const SizedBox(height: 12),
            AppButton(
              label: DateFormat.yMMMM().format(selectedMonth),
              onPressed: onPickMonth,
              style: AppButtonStyle.secondary,
              size: AppButtonSize.small,
              icon: const Icon(Icons.calendar_today, size: 18),
              isExpanded: true,
            ),
          ],
        );
      } else {
        // Horizontal layout for larger screens
        return Row(
          children: [
            const Expanded(child: GaugeFilterDropdown()),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                label: DateFormat.yMMMM().format(selectedMonth),
                onPressed: onPickMonth,
                style: AppButtonStyle.secondary,
                size: AppButtonSize.small,
                icon: const Icon(Icons.calendar_today, size: 18),
              ),
            ),
          ],
        );
      }
    },
  );
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horiEdgePadding,
          vertical: 24,
        ),
        child: Column(
          children: [
            CardPlaceholder(height: 240),
            SizedBox(height: 24),
            CardPlaceholder(height: 200),
            SizedBox(height: 24),
            CardPlaceholder(height: 280),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.dailyBreakdownEmptyTitle,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.dailyBreakdownEmptyMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
