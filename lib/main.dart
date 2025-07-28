import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/internationalization.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await Firebase.initializeApp();
  await FlutterFlowTheme.initialize();

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  // Wrap the entire app in a ProviderScope for Riverpod state management.
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Convert MyApp to a ConsumerWidget to access Riverpod providers.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Watch the goRouterProvider to get the router instance.
    final GoRouter router = ref.watch(goRouterProvider);
    final ThemeMode themeMode = FlutterFlowTheme.themeMode;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "RainWise",
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: themeMode,
      // Use the routerConfig from our GoRouter instance.
      routerConfig: router,
    );
  }
}
