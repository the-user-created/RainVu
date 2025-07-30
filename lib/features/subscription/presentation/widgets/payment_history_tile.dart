import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/subscription/domain/payment_transaction.dart";

class PaymentHistoryTile extends StatelessWidget {
  const PaymentHistoryTile({required this.transaction, super.key});

  final PaymentTransaction transaction;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(transaction.date),
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              transaction.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(
          "${transaction.currencySymbol}${transaction.amount.toStringAsFixed(0)}",
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
