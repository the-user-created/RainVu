import "package:rain_wise/core/data/repositories/rain_gauge_repository.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "data_providers.g.dart";

/// Provides a stream of all user-managed rain gauges, ordered by name.
/// Ideal for reactive UI that needs to display a list of gauges.
@riverpod
Stream<List<RainGauge>> allGaugesStream(final Ref ref) =>
    ref.watch(rainGaugeRepositoryProvider).watchGauges();

/// Provides a future of all user-managed rain gauges.
/// Useful for one-time fetches, like populating a dropdown menu.
@riverpod
Future<List<RainGauge>> allGaugesFuture(final Ref ref) =>
    ref.watch(rainGaugeRepositoryProvider).fetchGauges();

/// Provides a future to fetch a single rain gauge by its ID.
@riverpod
Future<RainGauge?> gaugeById(final Ref ref, final String gaugeId) =>
    ref.watch(rainGaugeRepositoryProvider).getGaugeById(gaugeId);

/// Provides a stream that emits a value whenever the rainfall_entries table
/// is updated. Useful for invalidating other providers that depend on this data.
@riverpod
Stream<void> rainfallTableUpdates(final Ref ref) =>
    ref.watch(rainfallRepositoryProvider).watchTableUpdates();

/// Provides the earliest and latest dates of any rainfall entry in the database.
/// This is useful for constraining date pickers in analytical features.
@riverpod
Future<DateRangeResult> rainfallDateRange(final Ref ref) {
  ref.watch(rainfallTableUpdatesProvider);
  return ref.watch(rainfallRepositoryProvider).getDateRangeOfEntries();
}
