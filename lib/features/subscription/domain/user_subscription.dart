import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/l10n/app_localizations.dart";

part "user_subscription.freezed.dart";

enum SubscriptionStatus { active, free, cancelled }

extension SubscriptionStatusX on SubscriptionStatus {
  String displayName(final AppLocalizations l10n) {
    switch (this) {
      case SubscriptionStatus.active:
        return l10n.subscriptionStatusActive;
      case SubscriptionStatus.free:
        return l10n.subscriptionStatusFree;
      case SubscriptionStatus.cancelled:
        return l10n.subscriptionStatusCancelled;
    }
  }
}

@freezed
abstract class UserSubscription with _$UserSubscription {
  const factory UserSubscription({
    required final String planId,
    required final String planName,
    required final SubscriptionStatus status,
    required final String price,
    final DateTime? renewalDate,
  }) = _UserSubscription;
}
