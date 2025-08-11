import "package:flutter/material.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:rain_wise/features/comparative_analysis/presentation/widgets/yearly_summary_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class YearlySummaryList extends StatelessWidget {
  const YearlySummaryList({
    required this.summaries,
    super.key,
  });

  final List<YearlySummary> summaries;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final List<Color> colors = [colorScheme.secondary, colorScheme.tertiary];

    if (summaries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 4),
            child: Text(
              l10n.yearlySummaryTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
          ListView.separated(
            itemCount: summaries.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (final context, final index) =>
                const SizedBox(height: 12),
            itemBuilder: (final context, final index) => YearlySummaryCard(
              summary: summaries[index],
              color: colors[index % colors.length],
            ),
          ),
        ],
      ),
    );
  }
}
