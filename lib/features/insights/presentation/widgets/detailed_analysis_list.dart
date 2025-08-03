import "package:flutter/material.dart";
import "package:rain_wise/core/navigation/app_router.dart";

class DetailedAnalysisList extends StatelessWidget {
  const DetailedAnalysisList({super.key});

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detailed Analysis",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _AnalysisListTile(
            title: "Monthly Breakdown",
            subtitle: "View detailed monthly statistics",
            onTap: () => const MonthlyBreakdownRoute().push(context),
          ),
          const SizedBox(height: 16),
          _AnalysisListTile(
            title: "Seasonal Patterns",
            subtitle: "Analyze rainfall patterns by season",
            onTap: () => const SeasonalPatternsRoute().push(context),
          ),
          const SizedBox(height: 16),
          _AnalysisListTile(
            title: "Anomaly Exploration",
            subtitle: "Analyze unusual patterns in rainfall data",
            onTap: () => const AnomalyExplorationRoute().push(context),
          ),
          const SizedBox(height: 16),
          _AnalysisListTile(
            title: "Comparative Yearly Analysis",
            subtitle: "See side-by-side comparisons of multiple years",
            onTap: () => const ComparativeAnalysisRoute().push(context),
          ),
        ],
      ),
    );
  }
}

class _AnalysisListTile extends StatelessWidget {
  const _AnalysisListTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.secondary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
