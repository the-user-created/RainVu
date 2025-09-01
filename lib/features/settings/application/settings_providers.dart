import "package:riverpod_annotation/riverpod_annotation.dart";

part "settings_providers.g.dart";

/// Provider to get the last sync timestamp.
/// TODO: In a real app, this would fetch from a repository or local storage.
@riverpod
Future<DateTime?> lastSynced(final LastSyncedRef ref) async {
  // Mock implementation: return a recent date.
  // A small delay is added to simulate a network or async operation.
  await Future.delayed(const Duration(milliseconds: 500));
  return DateTime.now().subtract(const Duration(minutes: 15));
}
