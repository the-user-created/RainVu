import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/app_constants.dart";
import "package:rainvu/features/home/application/home_providers.dart";
import "package:rainvu/features/home/domain/home_data.dart";
import "package:rainvu/features/home/presentation/widgets/log_rain_sheet.dart";
import "package:rainvu/features/home/presentation/widgets/monthly_summary_card.dart";
import "package:rainvu/features/home/presentation/widgets/monthly_trend_chart.dart";
import "package:rainvu/features/home/presentation/widgets/ytd_summary_card.dart";
import "package:rainvu/features/manage_gauges/presentation/widgets/add_gauge_sheet.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/utils/adaptive_ui_helpers.dart";
import "package:rainvu/shared/widgets/buttons/expandable_fab.dart";
import "package:rainvu/shared/widgets/placeholders.dart";
import "package:shimmer/shimmer.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showLogRainSheet(final BuildContext context) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final context) => const LogRainSheet(),
    );
  }

  void _showAddGaugeSheet(final BuildContext context) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final context) => const AddGaugeSheet(),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AsyncValue<HomeData> homeDataAsync = ref.watch(
      homeScreenDataProvider,
    );
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l10n.appName, style: theme.textTheme.headlineLarge),
          elevation: 0,
        ),
        floatingActionButton: ExpandableFab(
          distance: 70,
          children: [
            ActionButton(
              onPressed: () => _showLogRainSheet(context),
              icon: const Icon(Icons.water_drop),
              label: l10n.fabLogRainfall,
            ),
            ActionButton(
              onPressed: () => _showAddGaugeSheet(context),
              icon: const Icon(Icons.straighten),
              label: l10n.fabAddGauge,
            ),
          ],
        ),
        body: SafeArea(
          child: homeDataAsync.when(
            loading: () => const _LoadingState(),
            error: (final err, final stack) {
              FirebaseCrashlytics.instance.recordError(
                err,
                stack,
                reason: "Failed to load home screen data",
              );
              return Center(child: Text(l10n.homeScreenError));
            },
            data: (final homeData) => ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horiEdgePadding,
              ),
              children: [
                const SizedBox(height: 16),
                MonthlySummaryCard(
                  monthlyTotal: homeData.monthlyTotal,
                  recentEntries: homeData.recentEntries,
                  currentMonthDate: homeData.currentMonthDate,
                ),
                const SizedBox(height: 24),
                YtdSummaryCard(
                  ytdTotal: homeData.ytdTotal,
                  annualAverage: homeData.annualAverage,
                ),
                const SizedBox(height: 24),
                MonthlyTrendChart(trends: homeData.monthlyTrends),
                const SizedBox(height: 96),
              ],
            ),
          ),
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
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horiEdgePadding,
        ),
        children: const [
          SizedBox(height: 16),
          CardPlaceholder(height: 200),
          SizedBox(height: 24),
          CardPlaceholder(height: 180),
          SizedBox(height: 24),
          CardPlaceholder(height: 300),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
