import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/data/providers/data_providers.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/features/monthly_breakdown/application/monthly_breakdown_provider.dart";
import "package:rain_wise/features/monthly_breakdown/domain/monthly_breakdown_data.dart";
import "package:rain_wise/features/monthly_breakdown/presentation/widgets/daily_rainfall_chart.dart";
import "package:rain_wise/features/monthly_breakdown/presentation/widgets/historical_comparison_card.dart";
import "package:rain_wise/features/monthly_breakdown/presentation/widgets/monthly_summary_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/pickers/month_year_picker.dart";

class MonthlyBreakdownScreen extends ConsumerStatefulWidget {
  const MonthlyBreakdownScreen({this.initialMonth, super.key});

  /// An optional initial month to display, in 'YYYY-MM' format.
  final String? initialMonth;

  @override
  ConsumerState<MonthlyBreakdownScreen> createState() =>
      _MonthlyBreakdownScreenState();
}

class _MonthlyBreakdownScreenState
    extends ConsumerState<MonthlyBreakdownScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    if (widget.initialMonth != null) {
      // Attempt to parse the provided month string.
      final List<String> parts = widget.initialMonth!.split("-");
      if (parts.length == 2) {
        final int? year = int.tryParse(parts[0]);
        final int? month = int.tryParse(parts[1]);
        if (year != null && month != null) {
          _selectedMonth = DateTime(year, month);
          return; // Exit if successful
        }
      }
    }
    // Fallback to the current month if no valid initialMonth is provided.
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  Future<void> _pickMonth() async {
    final DateRangeResult? dateRange = ref
        .read(rainfallDateRangeProvider)
        .value;
    if (dateRange?.min == null || dateRange?.max == null) {
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
    final AsyncValue<MonthlyBreakdownData> breakdownDataAsync = ref.watch(
      monthlyBreakdownProvider(_selectedMonth),
    );
    final AsyncValue<DateRangeResult> dateRangeAsync = ref.watch(
      rainfallDateRangeProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
            l10n.monthlyBreakdownTitle,
            style: theme.textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AppIconButton(
              icon: Icon(
                Icons.calendar_today,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: dateRangeAsync.when(
                data: (final data) =>
                    (data.min != null && data.max != null) ? _pickMonth : null,
                loading: () => null,
                error: (final _, final _) => null,
              ),
              tooltip: l10n.selectMonthTooltip,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: breakdownDataAsync.when(
          loading: () => const AppLoader(),
          error: (final err, final stack) => Center(
            child: Text(
              l10n.monthlyBreakdownError(err),
              style: theme.textTheme.bodyLarge,
            ),
          ),
          data: (final data) {
            if (data.summaryStats.totalRainfall == 0) {
              return const _EmptyState();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  MonthlySummaryCard(
                    stats: data.summaryStats,
                    selectedMonth: _selectedMonth,
                  ),
                  const SizedBox(height: 24),
                  HistoricalComparisonCard(
                    stats: data.historicalStats,
                    currentTotal: data.summaryStats.totalRainfall,
                  ),
                  const SizedBox(height: 24),
                  DailyRainfallChart(chartData: data.dailyChartData),
                ],
              ),
            );
          },
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
              l10n.monthlyBreakdownEmptyTitle,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.monthlyBreakdownEmptyMessage,
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
