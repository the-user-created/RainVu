import "package:riverpod_annotation/riverpod_annotation.dart";

part "settings_providers.g.dart";

/// Provider to determine if the user has a Pro subscription.
/// In a real app, this would check the user's status from a repository.
@riverpod
bool isProUser(final IsProUserRef ref) => true;
// Mock implementation: Assume the user is a Pro user.
// To test the alternative (hiding the 'Last Synced' footer), return false.

/// Provider to get the last sync timestamp.
/// In a real app, this would fetch from a repository or local storage.
@riverpod
Future<DateTime?> lastSynced(final LastSyncedRef ref) async {
  // Mock implementation: return a recent date.
  // A small delay is added to simulate a network or async operation.
  await Future.delayed(const Duration(milliseconds: 500));
  return DateTime.now().subtract(const Duration(minutes: 15));
}
