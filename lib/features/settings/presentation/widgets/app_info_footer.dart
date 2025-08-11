import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/settings/application/settings_providers.dart";
import "package:rain_wise/l10n/app_localizations.dart";

/// A footer widget that displays the "Last Synced" time.
/// It conditionally renders based on the user's subscription status.
class AppInfoFooter extends ConsumerWidget {
  const AppInfoFooter({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
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
            Text(
              l10n.appInfoFooterLastSynced,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            lastSyncedAsync.when(
              data: (final date) => Text(
                date != null
                    ? DateFormat("MM/dd/yyyy HH:mm").format(date)
                    : l10n.appInfoFooterLastSyncedNever,
                style: theme.textTheme.labelMedium,
              ),
              loading: () => const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (final err, final stack) => Text(
                l10n.appInfoFooterError,
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
