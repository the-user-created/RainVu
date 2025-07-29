import "package:cloud_firestore/cloud_firestore.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "support_repository.g.dart";

/// Repository for managing support tickets in Firestore.
class SupportRepository {
  SupportRepository(this._firestore);

  final FirebaseFirestore _firestore;
  static const String _ticketsPath = "supportTickets";

  /// Saves a [SupportTicket] to the Firestore collection.
  Future<void> submitTicket(final SupportTicket ticket) async {
    try {
      await _firestore
          .collection(_ticketsPath)
          .doc(ticket.id)
          .set(ticket.toJson());
    } on FirebaseException catch (e, st) {
      // In a real app, log this error to a monitoring service.
      Error.throwWithStackTrace(
        Exception("Failed to submit ticket. Please try again."),
        st,
      );
    }
  }
}

@riverpod
FirebaseFirestore firebaseFirestore(final FirebaseFirestoreRef ref) =>
    FirebaseFirestore.instance;

@riverpod
SupportRepository supportRepository(final SupportRepositoryRef ref) =>
    SupportRepository(ref.watch(firebaseFirestoreProvider));
