import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/l10n/app_localizations.dart";

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
  String displayName(final AppLocalizations l10n) {
    switch (this) {
      case TicketCategory.bugReport:
        return l10n.ticketCategoryBugReport;
      case TicketCategory.featureRequest:
        return l10n.ticketCategoryFeatureRequest;
      case TicketCategory.generalFeedback:
        return l10n.ticketCategoryGeneralFeedback;
      case TicketCategory.billingIssue:
        return l10n.ticketCategoryBillingIssue;
      case TicketCategory.other:
        return l10n.ticketCategoryOther;
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
    required final DateTime createdAt,
    final String? userId,
    final String? contactEmail,
  }) = _SupportTicket;

  factory SupportTicket.fromJson(final Map<String, dynamic> json) =>
      _$SupportTicketFromJson(json);
}
