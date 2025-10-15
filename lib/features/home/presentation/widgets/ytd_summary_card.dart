import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/navigation/app_router.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";

class YtdSummaryCard extends ConsumerStatefulWidget {
  const YtdSummaryCard({
    required this.ytdTotal,
    required this.annualAverage,
    super.key,
  });

  final double ytdTotal;
  final double annualAverage;

  @override
  ConsumerState<YtdSummaryCard> createState() => _YtdSummaryCardState();
}

class _YtdSummaryCardState extends ConsumerState<YtdSummaryCard> {
  bool _isPressed = false;

  void _handleTap() {
    const YearlyComparisonRoute().push(context);
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final double progress = widget.annualAverage > 0
        ? min(widget.ytdTotal / widget.annualAverage, 1)
        : 0.0;

    return GestureDetector(
      onTapDown: (final _) => setState(() => _isPressed = true),
      onTapUp: (final _) {
        setState(() => _isPressed = false);
        _handleTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child:
          Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ytdProgressTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: theme.colorScheme.tertiary,
                            size: 36,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              widget.ytdTotal.formatRainfall(
                                context,
                                unit,
                                precision: 0,
                              ),
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  backgroundColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.tertiary,
                                  ),
                                )
                                .animate(delay: 200.ms)
                                .fadeIn(duration: 400.ms)
                                .slideX(
                                  begin: -0.5,
                                  duration: 400.ms,
                                  curve: Curves.easeOutCubic,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          l10n.ytdAnnualAverage(
                            widget.annualAverage.formatRainfall(
                              context,
                              unit,
                              precision: 0,
                            ),
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate(target: _isPressed ? 1 : 0)
              .scaleXY(end: 0.97, duration: 150.ms, curve: Curves.easeOut),
    );
  }
}
