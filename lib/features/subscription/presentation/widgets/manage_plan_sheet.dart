import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/subscription/application/subscription_provider.dart";
import "package:rain_wise/features/subscription/domain/subscription_plan.dart";
import "package:rain_wise/features/subscription/presentation/widgets/plan_comparison_card.dart";
import "package:rain_wise/flutter_flow/flutter_flow_icon_button.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class ManagePlanSheet extends ConsumerWidget {
  const ManagePlanSheet({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final AsyncValue<List<SubscriptionPlan>> plansAsync =
        ref.watch(availablePlansProvider);

    return Material(
      color: theme.secondaryBackground,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Manage Plan", style: theme.headlineMedium),
                FlutterFlowIconButton(
                  borderRadius: 20,
                  buttonSize: 40,
                  icon: Icon(Icons.close, color: theme.primaryText, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: plansAsync.when(
              data: (final plans) => ListView(
                controller: scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  ...plans
                      .map((final plan) => PlanComparisonCard(plan: plan))
                      .divide(const SizedBox(height: 16)),
                  const SizedBox(height: 24),
                  Text(
                    "Subscriptions automatically renew unless canceled. Manage billing through your device's app store.",
                    textAlign: TextAlign.center,
                    style: theme.bodySmall,
                  ),
                ],
              ),
              loading: () => const AppLoader(),
              error: (final err, final stack) =>
                  Center(child: Text("Error loading plans: $err")),
            ),
          ),
        ],
      ),
    );
  }
}
