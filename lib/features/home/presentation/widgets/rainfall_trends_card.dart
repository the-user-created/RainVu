import "package:flutter/material.dart";
import "package:rain_wise/core/navigation/app_router.dart";

// TODO: Consider using a charting library like fl_chart

class RainfallTrendsCard extends StatefulWidget {
  const RainfallTrendsCard({super.key});

  @override
  State<RainfallTrendsCard> createState() => _RainfallTrendsCardState();
}

class _RainfallTrendsCardState extends State<RainfallTrendsCard> {
  bool _is7Days = true;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
            _buildHeader(theme),
            const SizedBox(height: 16),
            _buildChart(theme), // Placeholder chart
            const SizedBox(height: 12),
            _buildViewInsightsButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(final ThemeData theme) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Rainfall Trends",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildTimeframeSelector(theme),
        ],
      );

  Widget _buildTimeframeSelector(final ThemeData theme) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeframeOption(
            "7 days",
            _is7Days,
            () {
              if (!_is7Days) {
                setState(() => _is7Days = true);
              }
            },
          ),
          Text(
            " | ",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          _buildTimeframeOption(
            "30 days",
            !_is7Days,
            () {
              if (_is7Days) {
                setState(() => _is7Days = false);
              }
            },
          ),
        ],
      );

  Widget _buildTimeframeOption(
    final String text,
    final bool isSelected,
    final VoidCallback onTap,
  ) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isSelected
              ? theme.colorScheme.secondary
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  // TODO: Replace with a real chart widget (e.g., fl_chart) and real data
  Widget _buildChart(final ThemeData theme) => Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "Chart will be displayed here",
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      );

  Widget _buildViewInsightsButton(
    final BuildContext context,
    final ThemeData theme,
  ) =>
      InkWell(
        onTap: () => const InsightsRoute().go(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "View detailed insights",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward,
              color: theme.colorScheme.secondary,
              size: 18,
            ),
          ],
        ),
      );
}
