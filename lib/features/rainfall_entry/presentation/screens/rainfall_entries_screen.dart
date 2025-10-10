import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/rainfall_entry/application/rainfall_entry_provider.dart";
import "package:rain_wise/features/rainfall_entry/presentation/widgets/rainfall_entry_list_item.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rainfall_entry.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class RainfallEntriesScreen extends ConsumerStatefulWidget {
  const RainfallEntriesScreen({
    // Expects a 'YYYY-MM' string from router
    required this.month,
    super.key,
  });

  final String month;

  @override
  ConsumerState<RainfallEntriesScreen> createState() =>
      _RainfallEntriesScreenState();
}

class _RainfallEntriesScreenState extends ConsumerState<RainfallEntriesScreen> {
  final Set<int> _animatedIndices = {};
  int? _staggerCountThreshold;

  // Estimated height of a single RainfallEntryListItem including its margin.
  // Card margin is 8px top/bottom (16 total) + padding/content.
  static const double _estimatedItemHeight = 100;

  @override
  void initState() {
    super.initState();
    // Schedule the calculation to run after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateThreshold());
  }

  void _calculateThreshold() {
    if (!mounted || _staggerCountThreshold != null) {
      return;
    }

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    const double appBarHeight = kToolbarHeight;
    final double screenHeight = mediaQuery.size.height;
    final double topPadding = mediaQuery.padding.top;
    final double bottomPadding = mediaQuery.padding.bottom;

    final double availableHeight =
        screenHeight - appBarHeight - topPadding - bottomPadding;

    // Calculate how many items fit and add a small buffer.
    final int count = (availableHeight / _estimatedItemHeight).ceil() + 1;

    setState(() {
      _staggerCountThreshold = count;
    });
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final DateTime selectedMonth =
        DateTime.tryParse("${widget.month}-01") ?? DateTime.now();
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
              itemBuilder: (final context, final index) {
                final Widget listItem = RainfallEntryListItem(
                  entry: entries[index],
                );
                final bool hasBeenAnimated = _animatedIndices.contains(index);

                if (hasBeenAnimated) {
                  return listItem;
                }

                _animatedIndices.add(index);

                // Use the calculated threshold, with a safe fallback.
                final int threshold = _staggerCountThreshold ?? 10;
                final Duration delay = (index < threshold)
                    ? (50 * index).ms
                    : 0.ms;

                return listItem
                    .animate(delay: delay)
                    .fade(duration: 300.ms)
                    .slideX(
                      begin: -0.25,
                      duration: 300.ms,
                      curve: Curves.easeOutCubic,
                    );
              },
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
