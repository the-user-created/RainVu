import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/subscription/application/subscription_provider.dart";
import "package:rain_wise/features/subscription/domain/subscription_plan.dart";
import "package:rain_wise/features/subscription/domain/user_subscription.dart";
import "package:rain_wise/features/subscription/presentation/widgets/plan_feature_list.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class CurrentPlanCard extends ConsumerWidget {
  const CurrentPlanCard({required this.subscription, super.key});

  final UserSubscription subscription;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<SubscriptionPlan>> plansAsync =
        ref.watch(availablePlansProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surface,
        child: plansAsync.when(
          loading: () => const SizedBox(height: 200, child: AppLoader()),
          error: (final err, final _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Text(l10n.subscriptionPlanLoadFailed(err))),
          ),
          data: (final plans) {
            final SubscriptionPlan plan = plans.firstWhere(
              (final p) => p.id == subscription.planId,
              // Provide a fallback empty plan if not found.
              orElse: () => SubscriptionPlan(
                id: subscription.planId,
                name: subscription.planName,
                price: subscription.price,
                description: "",
                includedFeatures: [],
                excludedFeatures: [],
              ),
            );

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.planName,
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        subscription.price,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subscription.status.displayName(l10n),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondary,
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
                          l10n.subscriptionNextRenewalDate(
                            DateFormat.yMMMMd()
                                .format(subscription.renewalDate!),
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  PlanFeatureList(
                    includedFeatures: plan.includedFeatures,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
