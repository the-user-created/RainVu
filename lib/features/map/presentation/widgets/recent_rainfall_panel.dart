import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";
import "package:rain_wise/features/map/application/map_providers.dart";
import "package:rain_wise/features/map/domain/rainfall_map_entry.dart";
import "package:rain_wise/features/map/presentation/widgets/rainfall_list_item.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class RecentRainfallPanel extends ConsumerWidget {
  const RecentRainfallPanel({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<RainfallMapEntry>> recentEntries =
        ref.watch(recentRainfallProvider);

    return Material(
      color: Colors.transparent,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 300,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Rainfall",
                    style: theme.textTheme.headlineSmall,
                  ),
                  AppButton(
                    onPressed: () =>
                        context.goNamed(AppRouteNames.insightsName),
                    label: "View Graph",
                    style: AppButtonStyle.secondary,
                    size: AppButtonSize.small,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: recentEntries.when(
                  loading: () => const AppLoader(),
                  error: (final err, final stack) =>
                      Center(child: Text("Error: $err")),
                  data: (final entries) => ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: entries.length,
                    itemBuilder: (final context, final index) {
                      final RainfallMapEntry entry = entries[index];
                      return RainfallListItem(entry: entry);
                    },
                    separatorBuilder: (final context, final index) =>
                        const SizedBox(height: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().move(
          begin: const Offset(0, 100),
          end: Offset.zero,
          duration: 600.ms,
          curve: Curves.easeInOut,
        );
  }
}
