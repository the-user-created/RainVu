import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/ui/app_theme.dart";
import "package:rain_wise/core/ui/theme_provider.dart";
import "package:rain_wise/core/utils/formatters.dart";
import "package:rain_wise/l10n/app_localizations.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await Firebase.initializeApp();
  final container = ProviderContainer();
  await container.read(sharedPreferencesProvider.future);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  setTimeagoLocales();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    final ThemeMode themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp.router(
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
