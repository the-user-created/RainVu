import "package:freezed_annotation/freezed_annotation.dart";

part "faq.freezed.dart";

part "faq.g.dart";

@freezed
abstract class Faq with _$Faq {
  const factory Faq({
    required final String question,
    required final String answer,
  }) = _Faq;

  factory Faq.fromJson(final Map<String, dynamic> json) => _$FaqFromJson(json);
}
