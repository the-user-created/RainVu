import "package:rain_wise/features/map/data/map_repository.dart";
import "package:rain_wise/features/map/domain/rainfall_map_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "map_providers.g.dart";

@riverpod
Future<List<RainfallMapEntry>> recentRainfall(
  final RecentRainfallRef ref,
) async {
  final MapRepository repository = ref.watch(mapRepositoryProvider);
  return repository.fetchRecentEntries();
}
