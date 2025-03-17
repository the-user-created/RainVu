import "package:firebase_auth/firebase_auth.dart";

Future<UserCredential?> emailSignInFunc(
  final String email,
  final String password,
) =>
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.trim(), password: password);

Future<UserCredential?> emailCreateAccountFunc(
  final String email,
  final String password,
) =>
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
