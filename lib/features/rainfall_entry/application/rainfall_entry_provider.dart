import "package:rain_wise/core/analytics/analytics_service.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/shared/domain/rainfall_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "rainfall_entry_provider.g.dart";

@riverpod
Stream<List<RainfallEntry>> rainfallEntriesForMonth(
  final Ref ref,
  final DateTime month,
  final String? gaugeId,
) => ref
    .watch(rainfallRepositoryProvider)
    .watchEntriesForMonth(month, gaugeId: gaugeId);

@riverpod
class RainfallEntryNotifier extends _$RainfallEntryNotifier {
  @override
  void build() {
    // No state needed, just a container for business logic methods
  }

  Future<void> updateEntry(final RainfallEntry entry) async {
    final RainfallRepository repo = ref.read(rainfallRepositoryProvider);
    await repo.updateEntry(entry);
    await ref.read(analyticsServiceProvider).editRainEntry();
  }

  Future<void> deleteEntry(final String entryId) async {
    final RainfallRepository repo = ref.read(rainfallRepositoryProvider);
    await repo.deleteEntry(entryId);
    await ref.read(analyticsServiceProvider).deleteRainEntry();
  }
}
