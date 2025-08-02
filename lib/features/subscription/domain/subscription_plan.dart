import "package:freezed_annotation/freezed_annotation.dart";

part "subscription_plan.freezed.dart";

part "subscription_plan.g.dart";

@freezed
abstract class SubscriptionPlan with _$SubscriptionPlan {
  const factory SubscriptionPlan({
    required final String id,
    required final String name,
    required final String price,
    required final String description,
    required final List<String> includedFeatures,
    required final List<String> excludedFeatures,
    @Default(false) final bool isCurrent,
  }) = _SubscriptionPlan;

  factory SubscriptionPlan.fromJson(final Map<String, dynamic> json) =>
      _$SubscriptionPlanFromJson(json);
}
