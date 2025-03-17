import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDGTwP3mtyw9MvbzbbesdTH8y9gaMIZxFE",
            authDomain: "rainwise-50133.firebaseapp.com",
            projectId: "rainwise-50133",
            storageBucket: "rainwise-50133.firebasestorage.app",
            messagingSenderId: "339465368001",
            appId: "1:339465368001:web:90d7ecbc46307066f23f40",
            measurementId: "G-V7CZ5MR8WK"));
  } else {
    await Firebase.initializeApp();
  }
}
