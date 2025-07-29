import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/comparative_analysis_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/comparative_analysis/yearly_summary_card.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class YearlySummaryList extends StatelessWidget {
  const YearlySummaryList({
    required this.summaries,
    super.key,
  });

  final List<YearlySummary> summaries;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final List<Color> colors = [theme.primary, theme.tertiary];

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
              "Yearly Summary",
              style: theme.titleMedium,
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
