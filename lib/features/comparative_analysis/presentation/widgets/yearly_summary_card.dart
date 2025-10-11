import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";

class YearlySummaryCard extends ConsumerStatefulWidget {
  const YearlySummaryCard({
    required this.summary,
    required this.color,
    super.key,
  });

  final YearlySummary summary;
  final Color color;

  @override
  ConsumerState<YearlySummaryCard> createState() => _YearlySummaryCardState();
}

class _YearlySummaryCardState extends ConsumerState<YearlySummaryCard> {
  bool _isPressed = false;

  void _onTap() {
    // Navigate to MonthlyBreakdownScreen for January of the selected year
    final String monthParam = "${widget.summary.year}-01";
    MonthlyBreakdownRoute(month: monthParam).push(context);
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final bool isPositive = widget.summary.percentageChange >= 0;
    final Color changeColor = isPositive
        ? colorScheme.tertiary
        : colorScheme.error;
    final IconData changeIcon = isPositive
        ? Icons.trending_up
        : Icons.trending_down;
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    return Listener(
          onPointerDown: (final _) => setState(() => _isPressed = true),
          onPointerUp: (final _) => setState(() => _isPressed = false),
          onPointerCancel: (final _) => setState(() => _isPressed = false),
          child: Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: colorScheme.surface,
            child: InkWell(
              onTap: _onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.summary.year.toString(),
                          style: textTheme.headlineSmall?.copyWith(
                            color: widget.color,
                          ),
                        ),
                        if (widget.summary.percentageChange.isFinite &&
                            widget.summary.percentageChange != 0)
                          Row(
                            children: [
                              Icon(changeIcon, color: changeColor, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                widget.summary.percentageChange
                                    .formatPercentage(
                                      precision: 0,
                                      showPositiveSign: true,
                                    ),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: changeColor,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _StatItem(
                          label: l10n.yearlySummaryTotalAnnualRainfall,
                          value: widget.summary.totalRainfall.formatRainfall(
                            context,
                            unit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(target: _isPressed ? 1 : 0)
        .scaleXY(end: 0.97, duration: 150.ms, curve: Curves.easeOut);
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: textTheme.titleMedium),
      ],
    );
  }
}
