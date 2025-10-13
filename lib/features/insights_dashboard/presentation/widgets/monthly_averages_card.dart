import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";

// TODO: add 10yr+20yr avg comparisons if data is available

/// A card with a flexible height, designed to show a month's rainfall
/// total and its comparison to historical averages. It adapts to content
/// size, making it suitable for all accessibility settings.
class MonthlyAveragesCard extends ConsumerStatefulWidget {
  const MonthlyAveragesCard({required this.data, this.onTap, super.key});

  final MonthlyAveragesData data;
  final VoidCallback? onTap;

  @override
  ConsumerState<MonthlyAveragesCard> createState() =>
      _MonthlyAveragesCardState();
}

class _MonthlyAveragesCardState extends ConsumerState<MonthlyAveragesCard> {
  bool _isPressed = false;

  void _onHighlightChanged(final bool value) {
    if (mounted) {
      setState(() {
        _isPressed = value;
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Card(
        elevation: 2,
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: _onHighlightChanged,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // This Row + Expanded forces the Wrap to take up the full width,
                // allowing spaceBetween to work correctly.
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 16,
                        // Horizontal gap between items
                        runSpacing: 4,
                        // Vertical gap if items wrap
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(widget.data.month, style: textTheme.titleMedium),
                          Text(
                            widget.data.mtdTotal.formatRainfall(context, unit),
                            style: textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ComparisonRow(
                      label: l10n.mtdBreakdown2yrAvg,
                      currentValue: widget.data.mtdTotal,
                      comparisonValue: widget.data.twoYrAvg,
                      unit: unit,
                    ),
                    const SizedBox(height: 8),
                    _ComparisonRow(
                      label: l10n.mtdBreakdown5yrAvg,
                      currentValue: widget.data.mtdTotal,
                      comparisonValue: widget.data.fiveYrAvg,
                      unit: unit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.currentValue,
    required this.comparisonValue,
    required this.unit,
  });

  final String label;
  final double currentValue;
  final double comparisonValue;
  final MeasurementUnit unit;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ComparisonIcon(current: currentValue, comparison: comparisonValue),
            const SizedBox(width: 4),
            Text(
              comparisonValue.formatRainfall(context, unit),
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _ComparisonIcon extends StatelessWidget {
  const _ComparisonIcon({required this.current, required this.comparison});

  final double current;
  final double comparison;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (current > comparison) {
      return Icon(Icons.arrow_upward, color: colorScheme.tertiary, size: 16);
    } else if (current < comparison) {
      return Icon(Icons.arrow_downward, color: colorScheme.error, size: 16);
    } else {
      return Icon(
        Icons.horizontal_rule,
        color: colorScheme.secondary,
        size: 16,
      );
    }
  }
}
