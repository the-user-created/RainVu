import "dart:math";

import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/rainfall_entry/domain/rainfall_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "rainfall_entry_provider.g.dart";

// Mock repository to simulate data source interactions
class MockRainfallEntryRepository {
  MockRainfallEntryRepository()
      : _gauges = [
          const RainGauge(id: "gauge1", name: "Main Gauge"),
          const RainGauge(id: "gauge2", name: "Backyard Gauge"),
          const RainGauge(id: "gauge3", name: "Farm Plot A"),
        ],
        _entries = List.generate(50, (final index) {
          final DateTime date = DateTime.now().subtract(Duration(days: index));
          return RainfallEntry(
            id: "entry$index",
            amount: (Random().nextDouble() * 20).roundToDouble(),
            date: date,
            gaugeId: "gauge${Random().nextInt(3) + 1}",
            unit: "mm",
          );
        });
  final List<RainfallEntry> _entries;
  final List<RainGauge> _gauges;

  Future<List<RainfallEntry>> fetchEntriesForMonth(final DateTime month) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    final List<RainfallEntry> entriesForMonth = _entries
        .where(
          (final entry) =>
              entry.date.year == month.year && entry.date.month == month.month,
        )
        .toList();

    // Populate gauge data
    return entriesForMonth.map((final entry) {
      final RainGauge gauge = _gauges.firstWhere(
        (final g) => g.id == entry.gaugeId,
        orElse: () => const RainGauge(id: "unknown", name: "Unknown Gauge"),
      );
      return entry.copyWith(gauge: gauge);
    }).toList();
  }

  Future<List<RainGauge>> fetchGauges() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _gauges;
  }

  Future<void> updateEntry(final RainfallEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final int index = _entries.indexWhere((final e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
  }

  Future<void> deleteEntry(final String entryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.removeWhere((final e) => e.id == entryId);
  }
}

@riverpod
MockRainfallEntryRepository mockRainfallEntryRepository(
  final MockRainfallEntryRepositoryRef ref,
) =>
    MockRainfallEntryRepository();

@riverpod
Future<List<RainfallEntry>> rainfallEntriesForMonth(
  final RainfallEntriesForMonthRef ref,
  final DateTime month,
) =>
    ref.watch(mockRainfallEntryRepositoryProvider).fetchEntriesForMonth(month);

@riverpod
Future<List<RainGauge>> rainGauges(final RainGaugesRef ref) =>
    ref.watch(mockRainfallEntryRepositoryProvider).fetchGauges();

@riverpod
class RainfallEntryNotifier extends _$RainfallEntryNotifier {
  @override
  void build() {
    // No state needed, just a container for business logic methods
  }

  Future<void> updateEntry(final RainfallEntry entry) async {
    final MockRainfallEntryRepository repo =
        ref.read(mockRainfallEntryRepositoryProvider);
    await repo.updateEntry(entry);
    ref.invalidate(rainfallEntriesForMonthProvider);
  }

  Future<void> deleteEntry(final String entryId) async {
    final MockRainfallEntryRepository repo =
        ref.read(mockRainfallEntryRepositoryProvider);
    await repo.deleteEntry(entryId);
    ref.invalidate(rainfallEntriesForMonthProvider);
  }
}
