import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/rainfall_entry/data/rainfall_entry_repository.dart";
import "package:rain_wise/features/rainfall_entry/domain/rainfall_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "rainfall_entry_provider.g.dart";

@riverpod
Future<List<RainfallEntry>> rainfallEntriesForMonth(
  final RainfallEntriesForMonthRef ref,
  final DateTime month,
) =>
    ref.watch(rainfallEntryRepositoryProvider).fetchEntriesForMonth(month);

@riverpod
Future<List<RainGauge>> rainGauges(final RainGaugesRef ref) =>
    ref.watch(rainfallEntryRepositoryProvider).fetchGauges();

@riverpod
class RainfallEntryNotifier extends _$RainfallEntryNotifier {
  @override
  void build() {
    // No state needed, just a container for business logic methods
  }

  Future<void> updateEntry(final RainfallEntry entry) async {
    final RainfallEntryRepository repo =
        ref.read(rainfallEntryRepositoryProvider);
    await repo.updateEntry(entry);
    ref.invalidate(rainfallEntriesForMonthProvider);
  }

  Future<void> deleteEntry(final String entryId) async {
    final RainfallEntryRepository repo =
        ref.read(rainfallEntryRepositoryProvider);
    await repo.deleteEntry(entryId);
    ref.invalidate(rainfallEntriesForMonthProvider);
  }
}
