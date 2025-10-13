import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "support_repository.g.dart";

/// Repository for managing support tickets.
class SupportRepository {
  /// Saves a [SupportTicket].
  ///
  /// This is a mock implementation that simulates a network delay.
  Future<void> submitTicket(final SupportTicket ticket) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // TODO: In a real implementation, a network error might occur here.
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to submit support ticket to backend",
      );
      rethrow;
    }
  }
}

@riverpod
SupportRepository supportRepository(final Ref ref) => SupportRepository();
