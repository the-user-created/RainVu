import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainly/core/utils/extensions.dart";
import "package:rainly/features/manage_gauges/application/gauges_provider.dart";
import "package:rainly/features/manage_gauges/presentation/widgets/gauge_list_tile.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/domain/rain_gauge.dart";
import "package:rainly/shared/widgets/placeholders.dart";
import "package:shimmer/shimmer.dart";

class GaugeList extends ConsumerWidget {
  const GaugeList({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<RainGauge>> gaugesAsync = ref.watch(gaugesProvider);

    return gaugesAsync.when(
      loading: () => const _LoadingState(),
      error: (final err, final stack) {
        FirebaseCrashlytics.instance.recordError(
          err,
          stack,
          reason: "Failed to load gauge list",
        );
        return Center(child: Text(l10n.gaugeListError));
      },
      data: (final gauges) {
        if (gauges.isEmpty) {
          return const _EmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: gauges
              .asMap()
              .entries
              .map(
                (final entry) => GaugeListTile(gauge: entry.value)
                    .animate()
                    .fade(duration: 500.ms, delay: (entry.key * 50).ms)
                    .slideY(
                      begin: 0.2,
                      duration: 400.ms,
                      delay: (entry.key * 50).ms,
                      curve: Curves.easeOutCubic,
                    ),
              )
              .toList()
              .divide(const SizedBox(height: 12)),
        );
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: Column(
        children: [
          const CardPlaceholder(height: 80),
          const SizedBox(height: 12),
          const CardPlaceholder(height: 80),
          const SizedBox(height: 12),
          const CardPlaceholder(height: 80),
        ].divide(const SizedBox(height: 12)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.straighten_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.gaugeListEmptyTitle,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.gaugeListEmptyMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.95, 0.95)),
    );
  }
}
