import "package:flutter/material.dart";

import "package:rain_wise/auth/base_auth_user_provider.dart";

abstract class AuthManager {
  Future signOut();

  Future deleteUser(final BuildContext context);

  Future updateEmail(
      {required final String email, required final BuildContext context});

  Future resetPassword(
      {required final String email, required final BuildContext context});

  Future sendEmailVerification() async => currentUser?.sendEmailVerification();

  Future refreshUser() async => currentUser?.refreshUser();
}

mixin EmailSignInManager on AuthManager {
  Future<BaseAuthUser?> signInWithEmail(
    final BuildContext context,
    final String email,
    final String password,
  );

  Future<BaseAuthUser?> createAccountWithEmail(
    final BuildContext context,
    final String email,
    final String password,
  );
}

mixin AnonymousSignInManager on AuthManager {
  Future<BaseAuthUser?> signInAnonymously(final BuildContext context);
}

mixin AppleSignInManager on AuthManager {
  Future<BaseAuthUser?> signInWithApple(final BuildContext context);
}

mixin GoogleSignInManager on AuthManager {
  Future<BaseAuthUser?> signInWithGoogle(final BuildContext context);
}

mixin JwtSignInManager on AuthManager {
  Future<BaseAuthUser?> signInWithJwtToken(
    final BuildContext context,
    final String jwtToken,
  );
}

mixin PhoneSignInManager on AuthManager {
  Future beginPhoneAuth({
    required final BuildContext context,
    required final String phoneNumber,
    required final void Function(BuildContext) onCodeSent,
  });

  Future verifySmsCode({
    required final BuildContext context,
    required final String smsCode,
  });
}

mixin FacebookSignInManager on AuthManager {
  Future<BaseAuthUser?> signInWithFacebook(final BuildContext context);
}

mixin MicrosoftSignInManager on AuthManager {
  Future<BaseAuthUser?> signInWithMicrosoft(
    final BuildContext context,
    final List<String> scopes,
    final String tenantId,
  );
}

mixin GithubSignInManager on AuthManager {
  Future<BaseAuthUser?> signInWithGithub(final BuildContext context);
}
