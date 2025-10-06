import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/rainfall_entry/application/rainfall_entry_provider.dart";
import "package:rain_wise/features/rainfall_entry/presentation/widgets/rainfall_entry_list_item.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rainfall_entry.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class RainfallEntriesScreen extends ConsumerWidget {
  const RainfallEntriesScreen({
    // Expects a 'YYYY-MM' string from router
    required this.month,
    super.key,
  });

  final String month;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final DateTime selectedMonth =
        DateTime.tryParse("$month-01") ?? DateTime.now();
    final AsyncValue<List<RainfallEntry>> entriesAsync = ref.watch(
      rainfallEntriesForMonthProvider(selectedMonth),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMM().format(selectedMonth),
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: entriesAsync.when(
          loading: () => const AppLoader(),
          error: (final err, final stack) =>
              Center(child: Text(l10n.rainfallEntriesError(err))),
          data: (final entries) {
            if (entries.isEmpty) {
              return const _EmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: entries.length,
              itemBuilder: (final context, final index) =>
                  RainfallEntryListItem(entry: entries[index]),
            );
          },
        ),
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
              Icons.list_alt_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.rainfallEntriesEmptyTitle,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.rainfallEntriesEmptyMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
