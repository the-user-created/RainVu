import "package:flutter/material.dart";
import "package:rain_wise/features/subscription/domain/subscription_plan.dart";
import "package:rain_wise/features/subscription/presentation/widgets/plan_feature_list.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class PlanComparisonCard extends StatelessWidget {
  const PlanComparisonCard({
    required this.plan,
    super.key,
  });

  final SubscriptionPlan plan;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final isFree = plan.id == "free_plan";
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: theme.textTheme.headlineSmall,
                    ),
                    Text(
                      plan.price,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (plan.isCurrent)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Current",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            PlanFeatureList(
              includedFeatures: plan.includedFeatures,
              excludedFeatures: plan.excludedFeatures,
            ),
            const SizedBox(height: 16),
            if (!plan.isCurrent)
              AppButton(
                onPressed: () {
                  // TODO: Wire up to provider
                },
                label: isFree ? "Downgrade to Free" : "Upgrade to Pro",
                isExpanded: true,
                style: isFree
                    ? AppButtonStyle.outlineDestructive
                    : AppButtonStyle.primary,
              ),
          ],
        ),
      ),
    );
  }
}
