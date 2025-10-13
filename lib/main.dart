import "dart:async";

import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/data/local/shared_prefs.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/ui/app_theme.dart";
import "package:rain_wise/core/ui/theme_provider.dart";
import "package:rain_wise/core/utils/formatters.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/firebase_options.dart";
import "package:rain_wise/l10n/app_localizations.dart";

void main() async {
  // Use runZonedGuarded to catch all errors that are not caught by Flutter.
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        // Pass all uncaught "fatal" errors from the framework to Crashlytics.
        FlutterError.onError = (final errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        // Pass all uncaught asynchronous errors that aren't handled by the
        // Flutter framework to Crashlytics.
        PlatformDispatcher.instance.onError = (final error, final stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true; // Indicate that we've handled this error.
        };
      } catch (e, s) {
        // Firebase initialization failed. Log to the console for debugging
        // during development, but allow the app to continue running for users.
        debugPrint("Firebase initialization error: $e");
        debugPrintStack(stackTrace: s);
      }

      final container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      setTimeagoLocales();

      runApp(
        UncontrolledProviderScope(container: container, child: const MyApp()),
      );
    },
    (final error, final stack) {
      // Errors caught by the Zone.
      // This will only be effective if Firebase initialized successfully.
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    final ThemeMode themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: snackbarKey,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (final context) => AppLocalizations.of(context).appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
