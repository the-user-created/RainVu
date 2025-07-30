import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/subscription/application/subscription_provider.dart";
import "package:rain_wise/features/subscription/domain/payment_transaction.dart";
import "package:rain_wise/features/subscription/presentation/widgets/payment_history_tile.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class PaymentHistoryCard extends ConsumerWidget {
  const PaymentHistoryCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final AsyncValue<List<PaymentTransaction>> historyAsync =
        ref.watch(paymentHistoryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.primaryBackground,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Payment History", style: theme.headlineSmall),
              const SizedBox(height: 16),
              historyAsync.when(
                data: (final history) => Column(
                  children: history
                      .map((final txn) => PaymentHistoryTile(transaction: txn))
                      .divide(const SizedBox(height: 12)),
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: AppLoader(),
                  ),
                ),
                error: (final err, final stack) => Center(
                  child: Text("Could not load history: $err"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
