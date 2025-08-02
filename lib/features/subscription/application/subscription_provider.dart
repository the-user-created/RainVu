import "package:rain_wise/features/subscription/data/subscription_repository.dart";
import "package:rain_wise/features/subscription/domain/payment_transaction.dart";
import "package:rain_wise/features/subscription/domain/subscription_plan.dart";
import "package:rain_wise/features/subscription/domain/user_subscription.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "subscription_provider.g.dart";

@riverpod
Future<UserSubscription> userSubscription(final UserSubscriptionRef ref) async {
  final SubscriptionRepository repo = ref.watch(subscriptionRepositoryProvider);
  return repo.fetchUserSubscription();
}

@riverpod
Future<List<SubscriptionPlan>> availablePlans(
  final AvailablePlansRef ref,
) async {
  final SubscriptionRepository repo = ref.watch(subscriptionRepositoryProvider);
  return repo.fetchAvailablePlans();
}

@riverpod
Future<List<PaymentTransaction>> paymentHistory(
  final PaymentHistoryRef ref,
) async {
  final SubscriptionRepository repo = ref.watch(subscriptionRepositoryProvider);
  return repo.fetchPaymentHistory();
}

@riverpod
class SubscriptionService extends _$SubscriptionService {
  @override
  void build() {
    // No initial state
  }

  Future<void> cancelSubscription() async {
    final SubscriptionRepository repo =
        ref.read(subscriptionRepositoryProvider);
    await repo.cancelSubscription();
    // Invalidate providers to refetch data after mutation
    ref.invalidate(userSubscriptionProvider);
  }

  Future<void> changePlan(final String newPlanId) async {
    final SubscriptionRepository repo =
        ref.read(subscriptionRepositoryProvider);
    await repo.changePlan(newPlanId);
    ref.invalidate(userSubscriptionProvider);
  }
}
