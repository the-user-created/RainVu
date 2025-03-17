import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter/material.dart";
import "package:rain_wise/auth/auth_manager.dart";
import "package:rain_wise/auth/firebase_auth/anonymous_auth.dart";
import "package:rain_wise/auth/firebase_auth/apple_auth.dart";
import "package:rain_wise/auth/firebase_auth/email_auth.dart";
import "package:rain_wise/auth/firebase_auth/firebase_user_provider.dart";
import "package:rain_wise/auth/firebase_auth/github_auth.dart";
import "package:rain_wise/auth/firebase_auth/google_auth.dart";
import "package:rain_wise/auth/firebase_auth/jwt_token_auth.dart";
import "package:rain_wise/backend/backend.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

export "../base_auth_user_provider.dart";

class FirebasePhoneAuthManager extends ChangeNotifier {
  bool? _triggerOnCodeSent;
  FirebaseAuthException? phoneAuthError;

  // Set when using phone verification (after phone number is provided).
  String? phoneAuthVerificationCode;

  // Set when using phone sign in in web mode (ignored otherwise).
  ConfirmationResult? webPhoneAuthConfirmationResult;

  // Used for handling verification codes for phone sign in.
  void Function(BuildContext)? _onCodeSent;

  bool get triggerOnCodeSent => _triggerOnCodeSent ?? false;

  set triggerOnCodeSent(final bool val) => _triggerOnCodeSent = val;

  void Function(BuildContext) get onCodeSent =>
      _onCodeSent == null ? (final _) {} : _onCodeSent!;

  set onCodeSent(final void Function(BuildContext) func) => _onCodeSent = func;

  void update(final VoidCallback callback) {
    callback();
    notifyListeners();
  }
}

class FirebaseAuthManager extends AuthManager
    with
        EmailSignInManager,
        GoogleSignInManager,
        AppleSignInManager,
        AnonymousSignInManager,
        JwtSignInManager,
        GithubSignInManager,
        PhoneSignInManager {
  FirebasePhoneAuthManager phoneAuthManager = FirebasePhoneAuthManager();

  @override
  Future signOut() {
    logFirebaseEvent("SIGN_OUT");
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future deleteUser(final BuildContext context) async {
    try {
      if (!loggedIn) {
        debugPrint("Error: delete user attempted with no logged in user!");
        return;
      }
      await logFirebaseEvent("DELETE_USER");
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Too long since most recent sign in. Sign in again before deleting your account.")),
        );
      }
    }
  }

  @override
  Future updateEmail({
    required final String email,
    required final BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        debugPrint("Error: update email attempted with no logged in user!");
        return;
      }
      await currentUser?.updateEmail(email);
      await updateUserDocument(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Too long since most recent sign in. Sign in again before updating your email.")),
        );
      }
    }
  }

  Future updatePassword({
    required final String newPassword,
    required final BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        debugPrint("Error: update password attempted with no logged in user!");
        return;
      }
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message!}")),
        );
      }
    }
  }

  @override
  Future resetPassword({
    required final String email,
    required final BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message!}")),
      );
      return null;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password reset email sent")),
    );
  }

  @override
  Future<BaseAuthUser?> signInWithEmail(
    final BuildContext context,
    final String email,
    final String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailSignInFunc(email, password),
        "EMAIL",
      );

  @override
  Future<BaseAuthUser?> createAccountWithEmail(
    final BuildContext context,
    final String email,
    final String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailCreateAccountFunc(email, password),
        "EMAIL",
      );

  @override
  Future<BaseAuthUser?> signInAnonymously(
    final BuildContext context,
  ) =>
      _signInOrCreateAccount(context, anonymousSignInFunc, "ANONYMOUS");

  @override
  Future<BaseAuthUser?> signInWithApple(final BuildContext context) =>
      _signInOrCreateAccount(context, appleSignIn, "APPLE");

  @override
  Future<BaseAuthUser?> signInWithGoogle(final BuildContext context) =>
      _signInOrCreateAccount(context, googleSignInFunc, "GOOGLE");

  @override
  Future<BaseAuthUser?> signInWithGithub(final BuildContext context) =>
      _signInOrCreateAccount(context, githubSignInFunc, "GITHUB");

  @override
  Future<BaseAuthUser?> signInWithJwtToken(
    final BuildContext context,
    final String jwtToken,
  ) =>
      _signInOrCreateAccount(context, () => jwtTokenSignIn(jwtToken), "JWT");

  void handlePhoneAuthStateChanges(final BuildContext context) {
    phoneAuthManager.addListener(() {
      if (!context.mounted) {
        return;
      }

      if (phoneAuthManager.triggerOnCodeSent) {
        phoneAuthManager.onCodeSent(context);
        phoneAuthManager
            .update(() => phoneAuthManager.triggerOnCodeSent = false);
      } else if (phoneAuthManager.phoneAuthError != null) {
        final FirebaseAuthException e = phoneAuthManager.phoneAuthError!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: ${e.message!}"),
        ));
        phoneAuthManager.update(() => phoneAuthManager.phoneAuthError = null);
      }
    });
  }

  @override
  Future beginPhoneAuth({
    required final BuildContext context,
    required final String phoneNumber,
    required final void Function(BuildContext) onCodeSent,
  }) async {
    phoneAuthManager.update(() => phoneAuthManager.onCodeSent = onCodeSent);
    if (kIsWeb) {
      phoneAuthManager.webPhoneAuthConfirmationResult =
          await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
      phoneAuthManager.update(() => phoneAuthManager.triggerOnCodeSent = true);
      return;
    }
    final completer = Completer<bool>();
    // If you'd like auto-verification, without the user having to enter the SMS
    // code manually. Follow these instructions:
    // * For Android: https://firebase.google.com/docs/auth/android/phone-auth?authuser=0#enable-app-verification (SafetyNet set up)
    // * For iOS: https://firebase.google.com/docs/auth/ios/phone-auth?authuser=0#start-receiving-silent-notifications
    // * Finally modify verificationCompleted below as instructed.
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration.zero,
      // Skips Android's default auto-verification
      verificationCompleted: (final phoneAuthCredential) async {
        await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
        phoneAuthManager.update(() {
          phoneAuthManager.triggerOnCodeSent = false;
          phoneAuthManager.phoneAuthError = null;
        });
        // If you've implemented auto-verification, navigate to home page or
        // onboarding page here manually. Uncomment the lines below and replace
        // DestinationPage() with the desired widget.
        // await Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => DestinationPage()),
        // );
      },
      verificationFailed: (final e) {
        phoneAuthManager.update(() {
          phoneAuthManager.triggerOnCodeSent = false;
          phoneAuthManager.phoneAuthError = e;
        });
        completer.complete(false);
      },
      codeSent: (final verificationId, final _) {
        phoneAuthManager.update(() {
          phoneAuthManager.phoneAuthVerificationCode = verificationId;
          phoneAuthManager.triggerOnCodeSent = true;
          phoneAuthManager.phoneAuthError = null;
        });
        completer.complete(true);
      },
      codeAutoRetrievalTimeout: (final _) {},
    );

    return completer.future;
  }

  @override
  Future verifySmsCode({
    required final BuildContext context,
    required final String smsCode,
  }) {
    if (kIsWeb) {
      return _signInOrCreateAccount(
        context,
        () => phoneAuthManager.webPhoneAuthConfirmationResult!.confirm(smsCode),
        "PHONE",
      );
    } else {
      final PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: phoneAuthManager.phoneAuthVerificationCode!,
        smsCode: smsCode,
      );
      return _signInOrCreateAccount(
        context,
        () => FirebaseAuth.instance.signInWithCredential(authCredential),
        "PHONE",
      );
    }
  }

  /// Tries to sign in or create an account using Firebase Auth.
  /// Returns the User object if sign in was successful.
  Future<BaseAuthUser?> _signInOrCreateAccount(
    final BuildContext context,
    final Future<UserCredential?> Function() signInFunc,
    final String authProvider,
  ) async {
    try {
      final UserCredential? userCredential = await signInFunc();
      await logFirebaseAuthEvent(userCredential?.user, authProvider);
      if (userCredential?.user != null) {
        await maybeCreateUser(userCredential!.user!);
      }
      return userCredential == null
          ? null
          : RainWiseFirebaseUser.fromUserCredential(userCredential);
    } on FirebaseAuthException catch (e) {
      final String errorMsg = switch (e.code) {
        "email-already-in-use" =>
          "Error: The email is already in use by a different account",
        "INVALID_LOGIN_CREDENTIALS" =>
          "Error: The supplied auth credential is incorrect, malformed or has expired",
        _ => "Error: ${e.message!}",
      };
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
      return null;
    }
  }
}
