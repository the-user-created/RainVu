import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/insights_data.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class KeyMetricsSection extends StatelessWidget {
  const KeyMetricsSection({
    required this.metrics,
    super.key,
  });

  final KeyMetrics metrics;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "Key Metrics",
              style: theme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetricCard(
                  title: "Total Rainfall",
                  value: "${metrics.totalRainfall} mm",
                  changeText:
                      "${metrics.totalRainfallPrevYearChange}% vs last year",
                  changeColor: metrics.totalRainfallPrevYearChange >= 0
                      ? theme.success
                      : theme.error,
                ),
                _MetricCard(
                  title: "MTD Total",
                  value: "${metrics.mtdTotal} mm",
                  changeText:
                      "${metrics.mtdTotalPrevMonthChange}% vs last month",
                  changeColor: metrics.mtdTotalPrevMonthChange >= 0
                      ? theme.success
                      : theme.error,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetricCard(
                  title: "YTD Total",
                  value: "${metrics.ytdTotal} mm",
                  changeText: "On track for yearly goal",
                  changeColor: theme.success,
                ),
                _MetricCard(
                  title: "Monthly Avg",
                  value: "${metrics.monthlyAvg} mm",
                  changeText: "Based on 12 month data",
                  changeColor: theme.secondaryText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.changeText,
    required this.changeColor,
  });

  final String title;
  final String value;
  final String changeText;
  final Color changeColor;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.42;

    return Material(
      color: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: cardWidth,
        height: 130,
        decoration: BoxDecoration(
          color: theme.alternate,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: theme.bodyMedium),
                  Icon(Icons.info_outline, color: theme.primary, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.headlineMedium.override(
                  fontFamily: "Readex Pro",
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                changeText,
                style: theme.bodySmall.override(
                  fontFamily: "Inter",
                  color: changeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
