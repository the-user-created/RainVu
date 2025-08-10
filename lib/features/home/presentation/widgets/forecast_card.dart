import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/home/application/home_providers.dart";
import "package:rain_wise/features/home/domain/forecast.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class ForecastCard extends ConsumerWidget {
  const ForecastCard({this.isProUser = false, super.key});

  final bool isProUser;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<ForecastDay>> forecastAsync =
        ref.watch(forecastProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: theme.shadowColor,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest,
          ],
          stops: const [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(l10n.forecastTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: isProUser ? 0 : 3,
                  sigmaY: isProUser ? 0 : 3,
                ),
                child: forecastAsync.when(
                  loading: () => const AppLoader(),
                  error: (final err, final _) =>
                      Center(child: Text(l10n.forecastError(err))),
                  data: (final forecastDays) => ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: forecastDays.length,
                    separatorBuilder: (final context, final index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (final context, final index) {
                      final ForecastDay day = forecastDays[index];
                      return _ForecastDayItem(day: day);
                    },
                  ),
                ),
              ),
            ),
            if (!isProUser) ...[
              const SizedBox(height: 16),
              Text(
                l10n.forecastUpgradePrompt,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ForecastDayItem extends StatelessWidget {
  const _ForecastDayItem({required this.day});

  final ForecastDay day;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day.day, style: theme.textTheme.bodySmall),
            Icon(day.icon, color: day.iconColor, size: 32),
            Text(day.temperature, style: theme.textTheme.bodyMedium),
            Text(
              day.chanceOfRain,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
          ].divide(const SizedBox(height: 8)),
        ),
      ),
    );
  }
}
