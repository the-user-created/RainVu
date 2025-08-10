import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/subscription/application/subscription_provider.dart";
import "package:rain_wise/features/subscription/domain/payment_transaction.dart";
import "package:rain_wise/features/subscription/presentation/widgets/payment_history_tile.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class PaymentHistoryCard extends ConsumerWidget {
  const PaymentHistoryCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<PaymentTransaction>> historyAsync =
        ref.watch(paymentHistoryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.subscriptionPaymentHistoryTitle,
                style: theme.textTheme.headlineSmall,
              ),
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
                  child: Text(l10n.subscriptionPaymentHistoryLoadFailed(err)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
