import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:rain_wise/auth/base_auth_user_provider.dart";
import "package:rxdart/rxdart.dart";

export "../base_auth_user_provider.dart";

class RainWiseFirebaseUser extends BaseAuthUser {
  RainWiseFirebaseUser(this.user);

  User? user;

  @override
  bool get loggedIn => user != null;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.uid,
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoURL,
        phoneNumber: user?.phoneNumber,
      );

  @override
  Future? delete() => user?.delete();

  @override
  Future? updateEmail(final String email) async {
    try {
      await user?.updateEmail(email);
    } catch (_) {
      await user?.verifyBeforeUpdateEmail(email);
    }
  }

  @override
  Future? updatePassword(final String newPassword) async {
    await user?.updatePassword(newPassword);
  }

  @override
  Future? sendEmailVerification() => user?.sendEmailVerification();

  @override
  bool get emailVerified {
    // Reloads the user when checking in order to get the most up to date
    // email verified status.
    if (loggedIn && !user!.emailVerified) {
      refreshUser();
    }
    return user?.emailVerified ?? false;
  }

  @override
  Future refreshUser() async {
    await FirebaseAuth.instance.currentUser
        ?.reload()
        .then((final _) => user = FirebaseAuth.instance.currentUser);
  }

  static BaseAuthUser fromUserCredential(final UserCredential userCredential) =>
      fromFirebaseUser(userCredential.user);

  static BaseAuthUser fromFirebaseUser(final User? user) =>
      RainWiseFirebaseUser(user);
}

Stream<BaseAuthUser> rainWiseFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((final user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<BaseAuthUser>(
      (final user) {
        currentUser = RainWiseFirebaseUser(user);
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.setUserIdentifier(user?.uid ?? "");
        }
        return currentUser!;
      },
    );
