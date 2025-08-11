import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/subscription/application/subscription_provider.dart";
import "package:rain_wise/features/subscription/domain/user_subscription.dart";
import "package:rain_wise/features/subscription/presentation/widgets/current_plan_card.dart";
import "package:rain_wise/features/subscription/presentation/widgets/manage_plan_sheet.dart";
import "package:rain_wise/features/subscription/presentation/widgets/payment_history_card.dart";
import "package:rain_wise/features/subscription/presentation/widgets/subscription_actions_card.dart";
import "package:rain_wise/features/subscription/presentation/widgets/subscription_terms_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
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
    final AppLocalizations l10n = AppLocalizations.of(context);
    // Show a confirmation dialog before cancelling
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: Text(l10n.subscriptionCancelDialogTitle),
        content: Text(l10n.subscriptionCancelDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.subscriptionCancelDialogDeny),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.subscriptionCancelDialogConfirm,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Add loading state indicator
      await ref.read(subscriptionServiceProvider.notifier).cancelSubscription();
      if (context.mounted) {
        showSnackbar(context, l10n.subscriptionCancelledSuccessMessage);
      }
    }
  }

  void _onViewBillingHelp(final BuildContext context) {
    const HelpRoute().push(context);
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<UserSubscription> userSubscription =
        ref.watch(userSubscriptionProvider);

    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      appBar: AppBar(
        title:
            Text(l10n.subscriptionTitle, style: theme.textTheme.headlineMedium),
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
          child: Text(l10n.subscriptionLoadFailed(error)),
        ),
      ),
    );
  }
}
