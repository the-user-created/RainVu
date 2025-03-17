import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:rain_wise/auth/firebase_auth/firebase_auth_manager.dart";
import "package:rain_wise/backend/backend.dart";
import "package:stream_transform/stream_transform.dart";

export "firebase_auth_manager.dart";

final _authManager = FirebaseAuthManager();

FirebaseAuthManager get authManager => _authManager;

String get currentUserEmail =>
    currentUserDocument?.email ?? currentUser?.email ?? "";

String get currentUserUid => currentUser?.uid ?? "";

String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? currentUser?.displayName ?? "";

String get currentUserPhoto =>
    currentUserDocument?.photoUrl ?? currentUser?.photoUrl ?? "";

String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? currentUser?.phoneNumber ?? "";

String get currentJwtToken => _currentJwtToken ?? "";

bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

/// Create a Stream that listens to the current user's JWT Token, since Firebase
/// generates a new token every hour.
String? _currentJwtToken;
final Stream<Future<String?>> jwtTokenStream = FirebaseAuth.instance
    .idTokenChanges()
    .map((final user) async => _currentJwtToken = await user?.getIdToken())
    .asBroadcastStream();

DocumentReference? get currentUserReference =>
    loggedIn ? UsersRecord.collection.doc(currentUser!.uid) : null;

UsersRecord? currentUserDocument;
final Stream<UsersRecord?> authenticatedUserStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((final user) => user?.uid ?? "")
    .switchMap(
      (final uid) => uid.isEmpty
          ? Stream.value(null)
          : UsersRecord.getDocument(UsersRecord.collection.doc(uid))
              .handleError((final _) {}),
    )
    .map((final user) => currentUserDocument = user)
    .asBroadcastStream();

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({required this.builder, super.key});

  final WidgetBuilder builder;

  @override
  Widget build(final BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (final context, final _) => builder(context),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder>.has("builder", builder));
  }
}
