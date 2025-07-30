import "package:flutter/material.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

/// A simple header widget for a section of settings.
class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.horiEdgePadding,
          24,
          AppConstants.horiEdgePadding,
          8,
        ),
        child: Text(
          title,
          style: FlutterFlowTheme.of(context).labelLarge,
        ),
      );
}
