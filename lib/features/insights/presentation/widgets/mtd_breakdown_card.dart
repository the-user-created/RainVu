import 'package:flutter/material.dart';
import 'package:rain_wise/features/insights/domain/insights_data.dart';
import 'package:rain_wise/flutter_flow/flutter_flow_theme.dart';

class MtdBreakdownCard extends StatelessWidget {
  const MtdBreakdownCard({
    super.key,
    required this.data,
  });

  final MonthlyComparisonData data;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Material(
      color: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.alternate,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.month,
                style: theme.titleMedium,
              ),
              const SizedBox(height: 8),
              _DataRow(
                label: 'Total',
                value: '${data.mtdTotal}mm',
              ),
              const SizedBox(height: 8),
              _ComparisonRow(
                label: '2yr avg',
                currentValue: data.mtdTotal,
                comparisonValue: data.twoYrAvg,
              ),
              const SizedBox(height: 8),
              _ComparisonRow(
                label: '5yr avg',
                currentValue: data.mtdTotal,
                comparisonValue: data.fiveYrAvg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.bodySmall.override(
            fontFamily: 'Inter',
            color: theme.secondaryText,
          ),
        ),
        Text(
          value,
          style: theme.bodyMedium,
        ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.currentValue,
    required this.comparisonValue,
  });

  final String label;
  final int currentValue;
  final int comparisonValue;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.bodySmall.override(
            fontFamily: 'Inter',
            color: theme.secondaryText,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ComparisonIcon(
              current: currentValue,
              comparison: comparisonValue,
            ),
            const SizedBox(width: 4),
            Text(
              '${comparisonValue}mm',
              style: theme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _ComparisonIcon extends StatelessWidget {
  const _ComparisonIcon({required this.current, required this.comparison});

  final int current;
  final int comparison;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    if (comparison > current) {
      return Icon(Icons.arrow_upward, color: theme.success, size: 16);
    } else if (comparison < current) {
      return Icon(Icons.arrow_downward, color: theme.error, size: 16);
    } else {
      return Icon(Icons.horizontal_rule, color: theme.info, size: 16);
    }
  }
}
