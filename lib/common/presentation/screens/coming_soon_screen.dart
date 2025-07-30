import "package:flutter/material.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/l10n/app_localizations.dart";

/// A generic placeholder screen for features that are not yet implemented.
///
/// This screen is intended for development purposes and should not be present
/// in release builds. It provides a consistent and clear UI for sections of
/// the app that are under construction.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    this.pageTitle,
    this.headline,
    this.message,
  });

  /// The title to display in the [AppBar].
  final String? pageTitle;

  /// The main headline to display on the screen.
  final String? headline;

  /// The descriptive message to display below the headline.
  final String? message;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        title: Text(
          pageTitle ?? l10n.comingSoon,
          style: theme.titleLarge,
        ),
        backgroundColor: theme.primaryBackground,
        iconTheme: IconThemeData(color: theme.primaryText),
        elevation: 1,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horiEdgePadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction_rounded,
                  size: 80,
                  color: theme.secondary,
                ),
                const SizedBox(height: 32),
                Text(
                  headline ?? l10n.comingSoonHeadline,
                  style: theme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  message ?? l10n.comingSoonMessage,
                  style: theme.bodyLarge.copyWith(color: theme.secondaryText),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
