import "dart:async";

import "package:rain_wise/features/home/data/home_repository.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "home_providers.g.dart";

/// Provider to fetch all data needed for the home screen in one go.
/// This is now a stream provider to reactively update the UI when data changes.
@riverpod
Stream<HomeData> homeScreenData(final HomeScreenDataRef ref) =>
    ref.watch(homeRepositoryProvider).watchHomeData();

/// Provider to fetch the list of user's rain gauges for selection.
@riverpod
Future<List<RainGauge>> userGauges(final UserGaugesRef ref) async =>
    ref.watch(homeRepositoryProvider).getUserGauges();

/// Controller for handling the logic of logging a new rainfall entry.
@riverpod
class LogRainController extends _$LogRainController {
  @override
  FutureOr<void> build() {
    // No-op. This notifier is used for its methods, not its state.
  }

  /// Saves a new rainfall entry.
  Future<bool> saveEntry({
    required final String gaugeId,
    required final double amount,
    required final String unit,
    required final DateTime date,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(homeRepositoryProvider).saveRainfallEntry(
            gaugeId: gaugeId,
            amount: amount,
            unit: unit,
            date: date,
          );

      state = const AsyncValue.data(null);
      return true; // Success
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false; // Failure
    }
  }
}
