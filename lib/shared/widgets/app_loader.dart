import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

/// A simple, centered circular progress indicator for use as a loading spinner.
///
/// This widget is intended to be used throughout the app to indicate that
/// data is being fetched or a process is running in the background. It uses
/// the primary theme color for consistency.
class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(final BuildContext context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            FlutterFlowTheme.of(context).primary,
          ),
        ),
      );
}
