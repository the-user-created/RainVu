import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";
import "package:rain_wise/features/subscription/application/subscription_provider.dart";
import "package:rain_wise/features/subscription/domain/user_subscription.dart";
import "package:rain_wise/features/subscription/presentation/widgets/current_plan_card.dart";
import "package:rain_wise/features/subscription/presentation/widgets/manage_plan_sheet.dart";
import "package:rain_wise/features/subscription/presentation/widgets/payment_history_card.dart";
import "package:rain_wise/features/subscription/presentation/widgets/subscription_actions_card.dart";
import "package:rain_wise/features/subscription/presentation/widgets/subscription_terms_card.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class SubscriptionDetailsScreen extends ConsumerWidget {
  const SubscriptionDetailsScreen({super.key});

  void _showManagePlanSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (final _, final controller) =>
              ManagePlanSheet(scrollController: controller),
        ),
      ),
    );
  }

  Future<void> _onCancelSubscription(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    // Show a confirmation dialog before cancelling
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text("Cancel Subscription"),
        content: const Text("Are you sure you want to cancel your Pro plan?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Yes, Cancel",
              style: TextStyle(color: FlutterFlowTheme.of(context).error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Add loading state indicator
      await ref.read(subscriptionServiceProvider.notifier).cancelSubscription();
      if (context.mounted) {
        showSnackbar(context, "Subscription cancelled successfully.");
      }
    }
  }

  void _onViewBillingHelp(final BuildContext context) {
    context.pushNamed(AppRouteNames.helpName);
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final AsyncValue<UserSubscription> userSubscription =
        ref.watch(userSubscriptionProvider);

    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        iconTheme: IconThemeData(color: theme.primaryText),
        title: Text("My Subscription", style: theme.headlineMedium),
        centerTitle: false,
      ),
      body: userSubscription.when(
        data: (final subscription) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              CurrentPlanCard(subscription: subscription),
              SubscriptionActionsCard(
                onManagePlan: () => _showManagePlanSheet(context),
                onCancel: () => _onCancelSubscription(context, ref),
              ),
              const PaymentHistoryCard(),
              SubscriptionTermsCard(
                onViewBillingHelp: () => _onViewBillingHelp(context),
              ),
            ].divide(const SizedBox(height: 24)),
          ),
        ),
        loading: () => const AppLoader(),
        error: (final error, final stack) => Center(
          child: Text("Failed to load subscription: $error"),
        ),
      ),
    );
  }
}
