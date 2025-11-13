import "package:collection/collection.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rainvu/app_constants.dart";
import "package:rainvu/core/application/filter_provider.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/data/providers/data_providers.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/features/rainfall_entry/application/rainfall_entry_provider.dart";
import "package:rainvu/features/rainfall_entry/presentation/widgets/rainfall_entry_list_item.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/rain_gauge.dart";
import "package:rainvu/shared/domain/rainfall_entry.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:rainvu/shared/widgets/gauge_filter_bar.dart";
import "package:rainvu/shared/widgets/gauge_filter_dropdown.dart";
import "package:rainvu/shared/widgets/placeholders.dart";
import "package:shimmer/shimmer.dart";

class RainfallEntriesScreen extends ConsumerStatefulWidget {
  const RainfallEntriesScreen({
    // Expects a 'YYYY-MM' string from router
    required this.month,
    this.gaugeId,
    super.key,
  });

  final String month;
  final String? gaugeId;

  @override
  ConsumerState<RainfallEntriesScreen> createState() =>
      _RainfallEntriesScreenState();
}

class _RainfallEntriesScreenState extends ConsumerState<RainfallEntriesScreen> {
  final Set<int> _animatedIndices = {};
  late String _selectedGaugeId;

  @override
  void initState() {
    super.initState();
    _selectedGaugeId = widget.gaugeId ?? allGaugesFilterId;
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final DateTime selectedMonth =
        DateTime.tryParse("${widget.month}-01") ?? DateTime.now();
    final String? filterGaugeId = _selectedGaugeId == allGaugesFilterId
        ? null
        : _selectedGaugeId;

    final AsyncValue<List<RainfallEntry>> entriesAsync = ref.watch(
      rainfallEntriesForMonthProvider(selectedMonth, filterGaugeId),
    );
    final AsyncValue<RainGauge?> gaugeAsync = filterGaugeId != null
        ? ref.watch(gaugeByIdProvider(filterGaugeId))
        : const AsyncValue.data(null);

    final String monthTitle = DateFormat.yMMMM().format(selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: gaugeAsync.when(
          data: (final gauge) {
            final String gaugeName;
            if (gauge == null) {
              gaugeName = l10n.allGaugesFilter;
            } else if (gauge.id == AppConstants.defaultGaugeId) {
              gaugeName = l10n.defaultGaugeName;
            } else {
              gaugeName = gauge.name;
            }
            final String fullTitle = "$monthTitle: $gaugeName";

            return Text(
              fullTitle,
              style: theme.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            );
          },
          loading: () => Text(monthTitle, style: theme.textTheme.titleLarge),
          error: (final _, final _) =>
              Text(monthTitle, style: theme.textTheme.titleLarge),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GaugeFilterBar(
              child: GaugeFilterDropdown(
                value: _selectedGaugeId,
                onChanged: (final value) {
                  if (value != null) {
                    setState(() => _selectedGaugeId = value);
                  }
                },
              ),
            ),
            Expanded(
              child: entriesAsync.when(
                loading: () => const _LoadingState(),
                error: (final err, final stack) {
                  FirebaseCrashlytics.instance.recordError(
                    err,
                    stack,
                    reason: "Failed to load rainfall entries for month",
                  );
                  return Center(child: Text(l10n.rainfallEntriesError));
                },
                data: (final entries) {
                  if (entries.isEmpty) {
                    return const _EmptyState();
                  }

                  // Group entries by day
                  final Map<DateTime, List<RainfallEntry>> groupedEntries =
                      groupBy(entries, (final entry) => entry.date.startOfDay);

                  // Sort dates in descending order
                  final List<DateTime> sortedDates =
                      groupedEntries.keys.toList()
                        ..sort((final a, final b) => b.compareTo(a));

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _MonthlySummaryCard(entries: entries)
                            .animate()
                            .fade(duration: 300.ms)
                            .slideY(begin: -0.1, curve: Curves.easeOutCubic),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        sliver: SliverList.builder(
                          itemCount: sortedDates.length,
                          itemBuilder: (final context, final index) {
                            final DateTime date = sortedDates[index];
                            final List<RainfallEntry> dayEntries =
                                groupedEntries[date]!;

                            final Widget dateGroup = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index > 0) const SizedBox(height: 16),
                                _DateHeader(date: date),
                                ...dayEntries.map(
                                  (final entry) =>
                                      RainfallEntryListItem(entry: entry),
                                ),
                              ],
                            );

                            final bool hasBeenAnimated = _animatedIndices
                                .contains(index);

                            if (hasBeenAnimated) {
                              return dateGroup;
                            }

                            _animatedIndices.add(index);
                            return dateGroup
                                .animate()
                                .fade(duration: 500.ms)
                                .slideY(
                                  begin: 0.2,
                                  duration: 400.ms,
                                  delay: (index * 50).ms,
                                  curve: Curves.easeOutCubic,
                                );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: CardPlaceholder(height: 90),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (final context, final index) => const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    LinePlaceholder(height: 16, width: 120),
                    SizedBox(height: 8),
                    CardPlaceholder(height: 80),
                    SizedBox(height: 6),
                    CardPlaceholder(height: 80),
                  ],
                ),
                childCount: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlySummaryCard extends ConsumerWidget {
  const _MonthlySummaryCard({required this.entries});

  final List<RainfallEntry> entries;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    final double totalRainfall = entries.map((final e) => e.amount).sum;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            _SummaryItem(
              icon: Icons.water_drop_outlined,
              label: l10n.rainfallEntriesTotalRainfall,
              value: totalRainfall.formatRainfall(context, unit),
            ),
            _SummaryItem(
              icon: Icons.format_list_numbered,
              label: l10n.rainfallEntriesTotalEntries,
              value: entries.length.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 0, 8),
      child: Text(
        DateFormat.yMMMd().format(date),
        style: textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
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
              Icons.cloud_off_outlined,
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
      ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.95, 0.95)),
    );
  }
}
