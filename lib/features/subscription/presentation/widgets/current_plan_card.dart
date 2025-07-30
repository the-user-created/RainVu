import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/subscription/domain/subscription_plan.dart";
import "package:rain_wise/features/subscription/domain/user_subscription.dart";
import "package:rain_wise/features/subscription/presentation/widgets/plan_feature_list.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class CurrentPlanCard extends StatelessWidget {
  const CurrentPlanCard({required this.subscription, super.key});

  final UserSubscription subscription;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    // This is mocked. In a real app, you'd fetch the full plan details.
    final mockPlan = SubscriptionPlan(
      id: subscription.planId,
      name: subscription.planName,
      price: subscription.price,
      description: "",
      includedFeatures: [
        "Unlimited rain guages",
        "Cloud sync",
        "Data export and import",
        "Detailed graphs",
        "Weather forecasts & alerts",
        "Advanced analytics",
      ],
      excludedFeatures: [],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.primaryBackground,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subscription.planName, style: theme.headlineSmall),
                  Text(
                    subscription.price,
                    style: theme.headlineSmall.override(
                      color: theme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subscription.status.displayName,
                  style: theme.bodySmall.override(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (subscription.renewalDate != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: Text(
                      "Next renewal on ${DateFormat.yMMMMd().format(subscription.renewalDate!)}",
                      style: theme.bodyMedium.override(
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                ),
              PlanFeatureList(
                includedFeatures: mockPlan.includedFeatures,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
