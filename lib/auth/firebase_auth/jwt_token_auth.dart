import "package:firebase_auth/firebase_auth.dart";

Future<UserCredential?> jwtTokenSignIn(final String jwtToken) =>
    FirebaseAuth.instance.signInWithCustomToken(jwtToken);
