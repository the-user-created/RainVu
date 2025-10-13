import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:rain_wise/features/settings/data/support_repository.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "support_provider.g.dart";

/// A service class that handles the business logic for creating and submitting
/// support tickets.
@riverpod
class SupportService extends _$SupportService {
  @override
  void build() {
    // No initial state required. This is a command-based service.
  }

  /// Creates and submits a new support ticket.
  Future<void> submitTicket({
    required final TicketCategory category,
    required final String description,
    final String? contactEmail,
  }) async {
    final SupportRepository supportRepository = ref.read(
      supportRepositoryProvider,
    );

    final ticket = SupportTicket(
      id: const Uuid().v4(),
      category: category,
      description: description,
      contactEmail: contactEmail,
      createdAt: DateTime.now(),
    );

    try {
      await supportRepository.submitTicket(ticket);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Support ticket submission failed in SupportService",
      );
      rethrow;
    }
  }
}
