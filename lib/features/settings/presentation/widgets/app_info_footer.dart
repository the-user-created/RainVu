import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/settings/application/settings_providers.dart";

/// A footer widget that displays the "Last Synced" time.
/// It conditionally renders based on the user's subscription status.
class AppInfoFooter extends ConsumerWidget {
  const AppInfoFooter({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool isPro = ref.watch(isProUserProvider);

    if (!isPro) {
      return const SizedBox.shrink();
    }

    final AsyncValue<DateTime?> lastSyncedAsync = ref.watch(lastSyncedProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Center(
        child: Column(
          children: [
            Text("Last Synced", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            lastSyncedAsync.when(
              data: (final date) => Text(
                date != null
                    ? DateFormat("MM/dd/yyyy HH:mm").format(date)
                    : "Never",
                style: theme.textTheme.labelMedium,
              ),
              loading: () => const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (final err, final stack) => Text(
                "Could not load data",
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: theme.colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
