import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";

/// A card with a fixed height and variable width, designed to show a
/// month's rainfall total and its comparison to historical averages.
class MonthlyComparisonCard extends ConsumerStatefulWidget {
  const MonthlyComparisonCard({required this.data, this.onTap, super.key});

  final MonthlyComparisonData data;
  final VoidCallback? onTap;
  static const double _cardHeight = 150;

  @override
  ConsumerState<MonthlyComparisonCard> createState() =>
      _MonthlyComparisonCardState();
}

class _MonthlyComparisonCardState extends ConsumerState<MonthlyComparisonCard> {
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

    return SizedBox(
      height: MonthlyComparisonCard._cardHeight,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Card(
          elevation: 2,
          color: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: _onHighlightChanged,
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.data.month, style: textTheme.titleMedium),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DataRow(
                          label: l10n.mtdBreakdownTotal,
                          value: widget.data.mtdTotal.formatRainfall(
                            context,
                            unit,
                          ),
                        ),
                        const SizedBox(height: 8),
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
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 24),
        Text(value, style: textTheme.bodyMedium),
      ],
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
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
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

    // The logic is inverted from the old card.
    // If current value is HIGHER than comparison, it's a positive trend (up arrow).
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
