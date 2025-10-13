import "package:flutter/material.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class AnalysisLinksSection extends StatelessWidget {
  const AnalysisLinksSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              l10n.moreAnalysisTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
          _AnalysisLinkTile(
            title: l10n.monthlyComparisonTitle,
            subtitle: l10n.detailedAnalysisMonthlyComparisonSubtitle,
            onTap: () => const MonthlyComparisonRoute().push(context),
          ),
          const SizedBox(height: 12),
          _AnalysisLinkTile(
            title: l10n.monthlyBreakdownTitle,
            subtitle: l10n.detailedAnalysisMonthlyBreakdownSubtitle,
            onTap: () => const MonthlyBreakdownRoute().push(context),
          ),
          const SizedBox(height: 12),
          _AnalysisLinkTile(
            title: l10n.seasonalPatternsTitle,
            subtitle: l10n.detailedAnalysisSeasonalPatternsSubtitle,
            onTap: () => const SeasonalPatternsRoute().push(context),
          ),
          const SizedBox(height: 12),
          _AnalysisLinkTile(
            title: l10n.unusualPatternsTitle,
            subtitle: l10n.detailedAnalysisUnusualPatternsSubtitle,
            onTap: () => const UnusualPatternsRoute().push(context),
          ),
          const SizedBox(height: 12),
          _AnalysisLinkTile(
            title: l10n.detailedAnalysisYearlyComparisonTitle,
            subtitle: l10n.detailedAnalysisYearlyComparisonSubtitle,
            onTap: () => const YearlyComparisonRoute().push(context),
          ),
        ],
      ),
    );
  }
}

class _AnalysisLinkTile extends StatelessWidget {
  const _AnalysisLinkTile({
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
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: theme.colorScheme.secondary),
            ],
          ),
        ),
      ),
    );
  }
}
