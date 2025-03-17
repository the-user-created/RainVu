import "dart:math";

import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:rain_wise/auth/firebase_auth/auth_util.dart";

const kMaxEventNameLength = 40;
const kMaxParameterLength = 100;

Future<void> logFirebaseEvent(final String eventName,
    {Map<String?, dynamic>? parameters}) async {
  // https://firebase.google.com/docs/reference/cpp/group/event-names
  assert(eventName.length <= kMaxEventNameLength);

  parameters ??= {};
  parameters
    ..putIfAbsent(
        "user", () => currentUserUid.isEmpty ? "unset" : currentUserUid)
    ..removeWhere((final k, final v) => k == null || v == null);
  final Map<String, dynamic> params =
      parameters.map((final k, final v) => MapEntry(k!, v));

  // FB Analytics allows num values but others need to be converted to strings
  // and cannot be more than 100 characters.
  for (final MapEntry<String, dynamic> entry in params.entries) {
    if (entry.value is! num) {
      var valStr = entry.value.toString();
      if (valStr.length > kMaxParameterLength) {
        valStr = valStr.substring(0, min(valStr.length, kMaxParameterLength));
      }
      params[entry.key] = valStr;
    }
  }

  await FirebaseAnalytics.instance
      .logEvent(name: eventName, parameters: params.cast<String, Object>());
}

Future<void> logFirebaseAuthEvent(final User? user, final String method) async {
  final isSignup = user!.metadata.creationTime == user.metadata.lastSignInTime;
  final authEvent = isSignup ? "sign_up" : "login";
  await logFirebaseEvent(authEvent, parameters: {"method": method});
}
