import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class DetailedAnalysisList extends StatelessWidget {
  const DetailedAnalysisList({super.key});

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detailed Analysis",
            style: theme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _AnalysisListTile(
            title: "Monthly Breakdown",
            subtitle: "View detailed monthly statistics",
            onTap: () => context.pushNamed(AppRouteNames.monthlyBreakdownName),
          ),
          const SizedBox(height: 16),
          _AnalysisListTile(
            title: "Seasonal Patterns",
            subtitle: "Analyze rainfall patterns by season",
            onTap: () => context.pushNamed(AppRouteNames.seasonPatternsName),
          ),
          const SizedBox(height: 16),
          _AnalysisListTile(
            title: "Anomaly Exploration",
            subtitle: "Analyze unusual patterns in rainfall data",
            onTap: () => context.pushNamed(AppRouteNames.anomalyExploreName),
          ),
          const SizedBox(height: 16),
          _AnalysisListTile(
            title: "Comparative Yearly Analysis",
            subtitle: "See side-by-side comparisons of multiple years",
            onTap: () =>
                context.pushNamed(AppRouteNames.comparativeAnalysisName),
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
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
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
                        style: theme.bodyLarge.override(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: theme.bodyMedium.override(
                          fontFamily: "Inter",
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.primary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
