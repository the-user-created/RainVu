import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/home/application/home_providers.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:rain_wise/features/home/presentation/widgets/forecast_card.dart";
import "package:rain_wise/features/home/presentation/widgets/home_app_bar.dart";
import "package:rain_wise/features/home/presentation/widgets/log_rain_sheet.dart";
import "package:rain_wise/features/home/presentation/widgets/monthly_summary_card.dart";
import "package:rain_wise/features/home/presentation/widgets/quick_stats_card.dart";
import "package:rain_wise/features/home/presentation/widgets/rainfall_trends_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showLogRainSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      context: context,
      builder: (final context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const LogRainSheet(),
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AsyncValue<HomeData> homeDataAsync =
        ref.watch(homeScreenDataProvider);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // TODO: Fetch user subscription status from a provider
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: HomeAppBar(
          onAddPressed: () => _showLogRainSheet(context),
        ),
        body: SafeArea(
          child: homeDataAsync.when(
            loading: () => const AppLoader(),
            error: (final err, final stack) => Center(
              child: Text(l10n.homeScreenError(err)),
            ),
            data: (final homeData) => RefreshIndicator(
              onRefresh: () => ref.refresh(homeScreenDataProvider.future),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horiEdgePadding,
                  ),
                  child: Column(
                    children: [
                      MonthlySummaryCard(
                        currentMonth: homeData.currentMonth,
                        monthlyTotal: homeData.monthlyTotal,
                        recentEntries: homeData.recentEntries,
                      ),
                      const ForecastCard(),
                      const RainfallTrendsCard(),
                      QuickStatsCard(stats: homeData.quickStats),
                    ]
                        .divide(const SizedBox(height: 24))
                        .addToStart(const SizedBox(height: 16))
                        .addToEnd(const SizedBox(height: 32)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
