import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/widgets.dart";
import "package:rainvu/core/utils/snackbar_service.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/utils/ui_helpers.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:url_launcher/url_launcher.dart" as launcher;

part "url_launcher_service.g.dart";

@riverpod
UrlLauncherService urlLauncherService(final Ref ref) => UrlLauncherService();

class UrlLauncherService {
  Future<void> launchExternalUrl(
    final BuildContext context,
    final String url,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Uri uri = Uri.parse(url);

    try {
      if (!await launcher.launchUrl(
        uri,
        mode: launcher.LaunchMode.externalApplication,
      )) {
        if (context.mounted) {
          showSnackbar(l10n.urlLaunchError, type: MessageType.error);
        }
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to launch URL: $url",
      );
      if (context.mounted) {
        showSnackbar(l10n.urlLaunchError, type: MessageType.error);
      }
    }
  }
}
