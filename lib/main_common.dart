import "dart:async";

import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rainvu/core/data/local/shared_prefs.dart";
import "package:rainvu/core/firebase/telemetry_manager.dart";
import "package:rainvu/core/navigation/app_router.dart";
import "package:rainvu/core/ui/app_theme.dart";
import "package:rainvu/core/ui/theme_provider.dart";
import "package:rainvu/core/utils/formatters.dart";
import "package:rainvu/core/utils/snackbar_service.dart";
import "package:rainvu/l10n/app_localizations.dart";

Future<void> mainCommon(final FirebaseOptions firebaseOptions) async {
  runZonedGuarded<Future<void>>(
    () async {
      final WidgetsBinding widgetsBinding =
          WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      final container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      try {
        // Use the provided firebaseOptions
        await Firebase.initializeApp(options: firebaseOptions);

        await container
            .read(telemetryManagerProvider.notifier)
            .applyPersistedSetting();

        FlutterError.onError = (final errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        PlatformDispatcher.instance.onError = (final error, final stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      } catch (e, s) {
        // Firebase initialization failed. Log to the console for debugging
        // during development, but allow the app to continue running for users.
        debugPrint("Firebase initialization error: $e");
        debugPrintStack(stackTrace: s);
      }

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
      // ignore: do_not_use_environment
      debugShowCheckedModeBanner: const String.fromEnvironment("app.flavor") == "dev",
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
