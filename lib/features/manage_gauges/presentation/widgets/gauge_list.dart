import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_list_tile.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class GaugeList extends ConsumerWidget {
  const GaugeList({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<RainGauge>> gaugesAsync = ref.watch(gaugesProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: const Color(0x33000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: gaugesAsync.when(
          loading: () => const Center(heightFactor: 3, child: AppLoader()),
          error: (final err, final stack) => Center(child: Text("Error: $err")),
          data: (final gauges) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Rain Gauges", style: theme.textTheme.titleLarge),
                  Text(
                    "${gauges.length} Active",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (gauges.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    "No rain gauges added yet.",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: gauges.length,
                  itemBuilder: (final _, final index) =>
                      GaugeListTile(gauge: gauges[index]),
                  separatorBuilder: (final _, final __) =>
                      const SizedBox(height: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
