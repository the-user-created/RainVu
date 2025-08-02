import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/features/insights/application/seasonal_patterns_provider.dart";
import "package:rain_wise/features/insights/domain/seasonal_patterns_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/seasonal_patterns/data_explanation_card.dart";
import "package:rain_wise/features/insights/presentation/widgets/seasonal_patterns/season_selector.dart";
import "package:rain_wise/features/insights/presentation/widgets/seasonal_patterns/seasonal_summary_card.dart";
import "package:rain_wise/features/insights/presentation/widgets/seasonal_patterns/seasonal_trend_chart.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class SeasonalPatternsScreen extends ConsumerWidget {
  const SeasonalPatternsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<SeasonalPatternsData> dataAsync =
        ref.watch(seasonalPatternsDataProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        leading: AppIconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: context.pop,
          tooltip: "Back",
        ),
        title: Text("Seasonal Patterns", style: theme.textTheme.headlineMedium),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _Header(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: dataAsync.when(
                loading: () =>
                    const Center(heightFactor: 10, child: AppLoader()),
                error: (final err, final stack) =>
                    Center(child: Text("Error: $err")),
                data: (final data) => Column(
                  children: [
                    SeasonalTrendChart(trendData: data.trendData),
                    const SizedBox(height: 24),
                    SeasonalSummaryCard(summary: data.summary),
                    const SizedBox(height: 24),
                    const DataExplanationCard(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// A private widget to encapsulate the header section of the screen.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore historical seasonal rainfall data and compare current trends with past patterns.",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            const SeasonSelector(),
          ],
        ),
      ),
    );
  }
}
