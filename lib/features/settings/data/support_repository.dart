import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "support_repository.g.dart";

/// Repository for managing support tickets.
class SupportRepository {
  /// Saves a [SupportTicket].
  ///
  /// This is a mock implementation that simulates a network delay.
  Future<void> submitTicket(final SupportTicket ticket) async {
    // TODO: Integrate with a Discord webhook or other support service.
    await Future.delayed(const Duration(seconds: 1));
  }
}

@riverpod
SupportRepository supportRepository(final SupportRepositoryRef ref) =>
    SupportRepository();
