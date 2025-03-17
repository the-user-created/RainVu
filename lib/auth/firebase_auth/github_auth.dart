import "package:firebase_auth/firebase_auth.dart";

// https://firebase.flutter.dev/docs/auth/social/#github
Future<UserCredential?> githubSignInFunc() {
  // Create a new provider
  GithubAuthProvider githubProvider = GithubAuthProvider();

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithPopup(githubProvider);
}
