import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/subscription/domain/payment_transaction.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class PaymentHistoryTile extends StatelessWidget {
  const PaymentHistoryTile({required this.transaction, super.key});

  final PaymentTransaction transaction;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(transaction.date),
              style: theme.bodyMedium,
            ),
            Text(
              transaction.description,
              style: theme.bodySmall.override(
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
        Text(
          "${transaction.currencySymbol}${transaction.amount.toStringAsFixed(0)}",
          style: theme.bodyMedium,
        ),
      ],
    );
  }
}
