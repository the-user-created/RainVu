import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class QuickStat {
  const QuickStat({required this.value, required this.label});

  final String value;
  final String label;
}

class QuickStatsCard extends StatelessWidget {
  const QuickStatsCard({required this.stats, super.key});

  final List<QuickStat> stats;

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
            color: Color(0x1A000000),
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Quick Stats",
              style: theme.titleMedium.override(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    stats.map((final stat) => _StatItem(stat: stat)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.stat});

  final QuickStat stat;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: theme.alternate,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                stat.value,
                style: theme.titleLarge.override(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat.label,
                textAlign: TextAlign.center,
                style: theme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
