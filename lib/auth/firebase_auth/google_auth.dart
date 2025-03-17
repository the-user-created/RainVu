import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:google_sign_in/google_sign_in.dart";

final _googleSignIn = GoogleSignIn(scopes: ["profile", "email"]);

Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  await signOutWithGoogle().catchError((final _) => null);
  final GoogleSignInAuthentication? auth =
      await (await _googleSignIn.signIn())?.authentication;
  if (auth == null) {
    return null;
  }
  final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: auth.idToken, accessToken: auth.accessToken);
  return FirebaseAuth.instance.signInWithCredential(credential);
}

Future signOutWithGoogle() => _googleSignIn.signOut();
