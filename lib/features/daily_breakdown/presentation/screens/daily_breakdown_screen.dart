import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainly/app_constants.dart";
import "package:rainly/core/data/providers/data_providers.dart";
import "package:rainly/core/data/repositories/rainfall_repository.dart";
import "package:rainly/core/utils/snackbar_service.dart";
import "package:rainly/features/daily_breakdown/application/daily_breakdown_provider.dart";
import "package:rainly/features/daily_breakdown/domain/daily_breakdown_data.dart";
import "package:rainly/features/daily_breakdown/presentation/widgets/daily_rainfall_chart.dart";
import "package:rainly/features/daily_breakdown/presentation/widgets/monthly_summary_card.dart";
import "package:rainly/features/daily_breakdown/presentation/widgets/past_averages_card.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/utils/ui_helpers.dart";
import "package:rainly/shared/widgets/buttons/app_icon_button.dart";
import "package:rainly/shared/widgets/pickers/month_year_picker.dart";
import "package:rainly/shared/widgets/placeholders.dart";
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.dailyBreakdownTitle,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
