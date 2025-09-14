import "package:rain_wise/features/map/data/map_repository.dart";
import "package:rain_wise/features/map/domain/rainfall_map_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "map_providers.g.dart";

@riverpod
Stream<List<RainfallMapEntry>> recentRainfall(
  final Ref ref,
) {
  final MapRepository repository = ref.watch(mapRepositoryProvider);
  return repository.watchRecentEntries();
}
