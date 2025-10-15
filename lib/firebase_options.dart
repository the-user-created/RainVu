import "package:firebase_core/firebase_core.dart" show FirebaseOptions;
import "package:flutter/foundation.dart" show kIsWeb;

import "package:rainvu/firebase_options_dev.dart" as dev;
import "package:rainvu/firebase_options_prod.dart" as prod;

const String _flavor = String.fromEnvironment("flavor");

/// A class that holds the default `FirebaseOptions` for the current platform.
///
/// The static `currentPlatform` getter will return the correct
/// options based on the compile-time `--dart-define=flavor=<flavor>` variable.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        "DefaultFirebaseOptions have not been configured for web.",
      );
    }

    switch (_flavor) {
      case "dev":
        print("🔥 Using DEV Firebase options");
        return dev.DefaultFirebaseOptions.currentPlatform;
      case "prod":
        print("🚀 Using PROD Firebase options");
        return prod.DefaultFirebaseOptions.currentPlatform;
      default:
        print(
          "⚠️ No flavor or unknown flavor specified, defaulting to PROD Firebase options",
        );
        return prod.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
