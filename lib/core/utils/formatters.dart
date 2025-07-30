import "package:intl/intl.dart";
import "package:timeago/timeago.dart" as timeago;

void _setTimeagoLocales() {
  timeago.setLocaleMessages("en", timeago.EnMessages());
  timeago.setLocaleMessages("en_short", timeago.EnShortMessages());
}

String dateTimeFormat(
  final String format,
  final DateTime? dateTime, {
  final String? locale,
}) {
  if (dateTime == null) {
    return "";
  }
  if (format == "relative") {
    _setTimeagoLocales();
    return timeago.format(dateTime, locale: locale, allowFromNow: true);
  }
  return DateFormat(format, locale).format(dateTime);
}
