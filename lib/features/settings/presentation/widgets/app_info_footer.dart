import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:rainvu/features/settings/application/settings_providers.dart";
import "package:rainvu/l10n/app_localizations.dart";

/// A footer widget that displays the app version and build number.
class AppInfoFooter extends ConsumerWidget {
  const AppInfoFooter({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    final AsyncValue<PackageInfo> appInfoAsync = ref.watch(appInfoProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Center(
        child: appInfoAsync.when(
          data: (final info) => Text(
            l10n.appVersion(info.version, info.buildNumber),
            style: theme.textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          loading: () => const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (final err, final stack) {
            FirebaseCrashlytics.instance.recordError(
              err,
              stack,
              reason: "Failed to load package info for app footer",
            );
            return Text(
              l10n.appInfoFooterError,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            );
          },
        ),
      ),
    );
  }
}
