import "package:freezed_annotation/freezed_annotation.dart";

part "user_subscription.freezed.dart";

enum SubscriptionStatus { active, free, cancelled }

extension SubscriptionStatusX on SubscriptionStatus {
  String get displayName {
    switch (this) {
      case SubscriptionStatus.active:
        return "Active";
      case SubscriptionStatus.free:
        return "Free Plan";
      case SubscriptionStatus.cancelled:
        return "Cancelled";
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
