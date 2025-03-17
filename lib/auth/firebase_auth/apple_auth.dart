import "dart:convert";
import "dart:math";

import "package:crypto/crypto.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:sign_in_with_apple/sign_in_with_apple.dart";

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([final int length = 32]) {
  const charset =
      "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._";
  final random = Random.secure();
  return List.generate(
      length, (final _) => charset[random.nextInt(charset.length)]).join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(final String input) {
  final Uint8List bytes = utf8.encode(input);
  final Digest digest = sha256.convert(bytes);
  return digest.toString();
}

Future<UserCredential> appleSignIn() async {
  if (kIsWeb) {
    final provider = OAuthProvider("apple.com")
      ..addScope("email")
      ..addScope("name");

    // Sign in the user with Firebase.
    return FirebaseAuth.instance.signInWithPopup(provider);
  }
  // To prevent replay attacks with the credential returned from Apple, we
  // include a nonce in the credential request. When signing in in with
  // Firebase, the nonce in the id token returned by Apple, is expected to
  // match the sha256 hash of `rawNonce`.
  final String rawNonce = generateNonce();
  final String nonce = sha256ofString(rawNonce);

  // Request credential for the currently signed in Apple account.
  final AuthorizationCredentialAppleID appleCredential =
      await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  // Create an `OAuthCredential` from the credential returned by Apple.
  final OAuthCredential oauthCredential = OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
    accessToken: appleCredential.authorizationCode,
  );

  // Sign in the user with Firebase. If the nonce we generated earlier does
  // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  final UserCredential user =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

  final String displayName = [
    appleCredential.givenName,
    appleCredential.familyName
  ].where((final name) => name != null).join(" ");

  // The display name does not automatically come with the user.
  if (displayName.isNotEmpty) {
    await user.user?.updateDisplayName(displayName);
  }

  return user;
}
