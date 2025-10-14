import "dart:async";

import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_native_splash/flutter_native_splash.dart"; // Import package
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rainly/core/data/local/shared_prefs.dart";
import "package:rainly/core/firebase/telemetry_manager.dart";
import "package:rainly/core/navigation/app_router.dart";
import "package:rainly/core/ui/app_theme.dart";
import "package:rainly/core/ui/theme_provider.dart";
import "package:rainly/core/utils/formatters.dart";
import "package:rainly/core/utils/snackbar_service.dart";
import "package:rainly/firebase_options.dart";
import "package:rainly/l10n/app_localizations.dart";

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      final WidgetsBinding widgetsBinding =
          WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(
        widgetsBinding: widgetsBinding,
      ); // Preserve splash
      await dotenv.load();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      final container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

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
