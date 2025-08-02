import "package:rain_wise/features/subscription/domain/payment_transaction.dart";
import "package:rain_wise/features/subscription/domain/subscription_plan.dart";
import "package:rain_wise/features/subscription/domain/user_subscription.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "subscription_repository.g.dart";

/// A repository to handle subscription and payment data.
///
/// This is a mock implementation and should be replaced with actual
/// data sources (e.g., Firebase, RevenueCat, Stripe).
class SubscriptionRepository {
  /// Fetches the current user's subscription details.
  Future<UserSubscription> fetchUserSubscription() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Mocked data
    return UserSubscription(
      planId: "pro_annual",
      planName: "Pro Plan",
      price: "R100/year",
      status: SubscriptionStatus.active,
      renewalDate: DateTime.now().add(const Duration(days: 300)),
    );
  }

  /// Fetches a list of available subscription plans.
  Future<List<SubscriptionPlan>> fetchAvailablePlans() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const SubscriptionPlan(
        id: "free_plan",
        name: "Free",
        price: "R0",
        description: "Forever Free",
        includedFeatures: [
          "Unlimited rainfall entries",
          "2 rain gauges",
          "Basic graphs and maps",
        ],
        excludedFeatures: [
          "Local data storage",
          "No data export",
          "No weather forecasts",
        ],
      ),
      const SubscriptionPlan(
        id: "pro_annual",
        name: "Pro",
        price: "R100/year",
        description: "Billed Annually",
        isCurrent: true,
        includedFeatures: [
          "Unlimited rain guages",
          "Cloud sync",
          "Data export and import",
          "Detailed graphs",
          "Weather forecasts & alerts",
          "Advanced analytics",
        ],
        excludedFeatures: [],
      ),
    ];
  }

  /// Fetches the user's payment history.
  Future<List<PaymentTransaction>> fetchPaymentHistory() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();
    return [
      PaymentTransaction(
        id: "txn_1",
        date: now.subtract(const Duration(days: 30)),
        description: "Pro Plan",
        amount: 100,
        currencySymbol: "R",
      ),
      PaymentTransaction(
        id: "txn_2",
        date: now.subtract(const Duration(days: 60)),
        description: "Pro Plan",
        amount: 100,
        currencySymbol: "R",
      ),
      PaymentTransaction(
        id: "txn_3",
        date: now.subtract(const Duration(days: 90)),
        description: "Pro Plan",
        amount: 100,
        currencySymbol: "R",
      ),
    ];
  }

  Future<void> cancelSubscription() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock cancellation logic
  }

  Future<void> changePlan(final String newPlanId) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock plan change logic
  }
}

@riverpod
SubscriptionRepository subscriptionRepository(
  final SubscriptionRepositoryRef ref,
) =>
    SubscriptionRepository();
