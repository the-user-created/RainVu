import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/shared/domain/rainfall_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "rainfall_entry_provider.g.dart";

@riverpod
Stream<List<RainfallEntry>> rainfallEntriesForMonth(
  final Ref ref,
  final DateTime month,
) => ref.watch(rainfallRepositoryProvider).watchEntriesForMonth(month);

@riverpod
class RainfallEntryNotifier extends _$RainfallEntryNotifier {
  @override
  void build() {
    // No state needed, just a container for business logic methods
  }

  Future<void> updateEntry(final RainfallEntry entry) async {
    final RainfallRepository repo = ref.read(rainfallRepositoryProvider);
    await repo.updateEntry(entry);
  }

  Future<void> deleteEntry(final String entryId) async {
    final RainfallRepository repo = ref.read(rainfallRepositoryProvider);
    await repo.deleteEntry(entryId);
  }
}
