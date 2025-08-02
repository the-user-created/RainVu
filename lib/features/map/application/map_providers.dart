import "package:rain_wise/features/map/domain/rainfall_map_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "map_providers.g.dart";

@riverpod
Future<List<RainfallMapEntry>> recentRainfall(
  final RecentRainfallRef ref,
) async {
  // In a real app, this would fetch data from a repository:
  // final rainfallRepository = ref.watch(rainfallRepositoryProvider);
  // return rainfallRepository.fetchRecentEntriesForMap(limit: 5);

  // For now, return mock data to replicate the original UI.
  await Future.delayed(
    const Duration(milliseconds: 500),
  ); // Simulate network delay
  return [
    RainfallMapEntry(
      id: "1",
      dateTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
      locationName: "Farm Location A",
      coordinates: "-33.8688, 151.2093",
      amount: 25,
      unit: "mm",
    ),
    RainfallMapEntry(
      id: "2",
      dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      locationName: "Farm Location B",
      coordinates: "-33.8712, 151.2045",
      amount: 12,
      unit: "mm",
    ),
  ];
}
