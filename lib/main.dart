import "dart:async";

import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:provider/provider.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/internationalization.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await Firebase.initializeApp();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState();
  await appState.initializePersistedState();

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  runApp(
    ChangeNotifierProvider(
      create: (final context) => appState,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale? _locale;
  final ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  late AppStateNotifier _appStateNotifier;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => AnimatedBuilder(
        animation: _appStateNotifier,
        builder: (final context, final _) {
          // Re-create the router configuration whenever app state changes.
          final GoRouter router = createRouter(_appStateNotifier);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: "RainWise",
            localizationsDelegates: const [
              FFLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FallbackMaterialLocalizationDelegate(),
              FallbackCupertinoLocalizationDelegate(),
            ],
            locale: _locale,
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
            themeMode: _themeMode,
            routerConfig: router,
          );
        },
      );
}
