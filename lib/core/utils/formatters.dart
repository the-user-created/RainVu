import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:timeago/timeago.dart" as timeago;

void setTimeagoLocales() {
  // TODO: Expand to include more locales?
  timeago.setLocaleMessages("en", timeago.EnMessages());
  timeago.setLocaleMessages("en_short", timeago.EnShortMessages());
}

String dateTimeFormat(
  final String format,
  final DateTime? dateTime, {
  final BuildContext? context,
  final String? locale,
}) {
  if (dateTime == null) {
    return "";
  }

  // Prefer the explicitly passed locale, otherwise get it from the context
  final String effectiveLocale = locale ??
      (context != null
          ? Localizations.localeOf(context).toLanguageTag()
          : "en");

  if (format == "relative") {
    return timeago.format(
      dateTime,
      locale: effectiveLocale,
      allowFromNow: true,
    );
  }

  return DateFormat(format, effectiveLocale).format(dateTime);
}
