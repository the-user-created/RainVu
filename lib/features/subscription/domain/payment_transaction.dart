import "package:freezed_annotation/freezed_annotation.dart";

part "payment_transaction.freezed.dart";

part "payment_transaction.g.dart";

@freezed
abstract class PaymentTransaction with _$PaymentTransaction {
  const factory PaymentTransaction({
    required final String id,
    required final DateTime date,
    required final String description,
    required final double amount,
    required final String currencySymbol,
  }) = _PaymentTransaction;

  factory PaymentTransaction.fromJson(final Map<String, dynamic> json) =>
      _$PaymentTransactionFromJson(json);
}
