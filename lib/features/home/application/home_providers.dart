import "dart:async";

import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:rainly/core/data/repositories/rainfall_repository.dart";
import "package:rainly/core/firebase/analytics_service.dart";
import "package:rainly/features/home/data/home_repository.dart";
import "package:rainly/features/home/domain/home_data.dart";
import "package:rainly/shared/domain/rainfall_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "home_providers.g.dart";

/// Provider to fetch all data needed for the home screen in one go.
/// This is now a stream provider to reactively update the UI when data changes.
@riverpod
Stream<HomeData> homeScreenData(final Ref ref) =>
    ref.watch(homeRepositoryProvider).watchHomeData();

/// Controller for handling the logic of logging a new rainfall entry.
@riverpod
class LogRainController extends _$LogRainController {
  @override
  FutureOr<void> build() {
    // No-op. This notifier is used for its methods, not its state.
  }

  /// Saves a new rainfall entry. Amount is expected in mm.
  Future<bool> saveEntry({
    required final String gaugeId,
    required final double amount,
    required final DateTime date,
    required final String unit,
  }) async {
    state = const AsyncValue.loading();
    try {
      final newEntry = RainfallEntry(
        amount: amount,
        date: date,
        gaugeId: gaugeId,
        unit: "mm",
      );
      await ref.read(rainfallRepositoryProvider).addEntry(newEntry);

      // Log analytics event
      await ref.read(analyticsServiceProvider).logRainEntry(unit: unit);

      state = const AsyncValue.data(null);
      return true; // Success
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason: "Failed to save rainfall entry",
      );
      state = AsyncValue.error(e, st);
      return false; // Failure
    }
  }
}
