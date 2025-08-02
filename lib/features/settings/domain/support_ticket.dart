import "package:cloud_firestore/cloud_firestore.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "support_ticket.freezed.dart";

part "support_ticket.g.dart";

/// Enum for categorizing support tickets for easier filtering and routing.
enum TicketCategory {
  bugReport,
  featureRequest,
  generalFeedback,
  billingIssue,
  other,
}

/// Extension to provide a user-friendly display name for each category.
extension TicketCategoryExtension on TicketCategory {
  String get displayName {
    switch (this) {
      case TicketCategory.bugReport:
        return "Bug Report";
      case TicketCategory.featureRequest:
        return "Feature Request";
      case TicketCategory.generalFeedback:
        return "General Feedback";
      case TicketCategory.billingIssue:
        return "Billing Issue";
      case TicketCategory.other:
        return "Other";
    }
  }
}

/// A data model representing a user-submitted support ticket.
@freezed
abstract class SupportTicket with _$SupportTicket {
  const factory SupportTicket({
    required final String id,
    required final TicketCategory category,
    required final String description,
    @TimestampConverter() required final DateTime createdAt,
    final String? userId,
    final String? contactEmail,
  }) = _SupportTicket;

  factory SupportTicket.fromJson(final Map<String, dynamic> json) =>
      _$SupportTicketFromJson(json);
}

/// Custom converter to handle Firestore's Timestamp objects.
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(final Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(final DateTime date) => Timestamp.fromDate(date);
}
