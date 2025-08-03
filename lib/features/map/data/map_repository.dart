import "package:rain_wise/features/map/domain/rainfall_map_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "map_repository.g.dart";

abstract class MapRepository {
  Future<List<RainfallMapEntry>> fetchRecentEntries();
}

@riverpod
MapRepository mapRepository(final MapRepositoryRef ref) => MockMapRepository();

class MockMapRepository implements MapRepository {
  @override
  Future<List<RainfallMapEntry>> fetchRecentEntries({
    final int limit = 5,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return [
      RainfallMapEntry(
        id: "1",
        dateTime:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
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
}
