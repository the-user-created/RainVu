import "dart:async";

import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:provider/provider.dart";
import "package:rain_wise/auth/firebase_auth/auth_util.dart";
import "package:rain_wise/auth/firebase_auth/firebase_user_provider.dart";
import "package:rain_wise/backend/firebase/firebase_config.dart";
import "package:rain_wise/backend/schema/users_record.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/internationalization.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
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

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale? _locale;

  final ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  late Stream<BaseAuthUser> userStream;

  final StreamSubscription<UsersRecord?> authUserSub =
      authenticatedUserStream.listen((final _) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = rainWiseFirebaseUserStream()
      ..listen((final user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((final _) {});
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  Future<void> dispose() async {
    await authUserSub.cancel();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => MaterialApp.router(
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
        routerConfig: _router,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<StreamSubscription<UsersRecord?>>(
          "authUserSub", authUserSub))
      ..add(
          DiagnosticsProperty<Stream<BaseAuthUser>>("userStream", userStream));
  }
}
