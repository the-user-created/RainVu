import "dart:math";
import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/insights_data.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class MonthlyTrendChart extends StatelessWidget {
  const MonthlyTrendChart({
    required this.trends,
    super.key,
  });

  final List<MonthlyTrendPoint> trends;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    const double chartContainerHeight = 200;
    const double chartContainerVPadding = 32;
    const double labelAreaHeight = 24;
    const double maxChartHeight =
        chartContainerHeight - chartContainerVPadding - labelAreaHeight;

    final double maxRainfall =
        trends.isEmpty ? 1.0 : trends.map((final e) => e.rainfall).reduce(max);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Monthly Trend", style: theme.headlineSmall),
                    Text(
                      "Last 12 Months",
                      style: theme.bodyMedium.override(
                        fontFamily: "Inter",
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: chartContainerHeight,
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.alternate),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: trends.map((final point) {
                      final double normalizedHeight = maxRainfall > 0
                          ? (point.rainfall / maxRainfall) * maxChartHeight
                          : 0.0;
                      return Expanded(
                        child: _ChartBar(
                          label: point.month,
                          height: normalizedHeight.clamp(5.0, maxChartHeight),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({required this.label, required this.height});

  final String label;
  final double height;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: theme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.bodySmall.override(fontFamily: "Inter"),
        ),
      ],
    );
  }
}
