import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

/// A simple header widget for a section of settings.
class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          valueOrDefault<double>(AppConstants.horiEdgePadding.toDouble(), 16),
          24, // Top padding
          valueOrDefault<double>(AppConstants.horiEdgePadding.toDouble(), 16),
          8, // Bottom padding
        ),
        child: Text(
          title,
          style: FlutterFlowTheme.of(context).labelLarge,
        ),
      );
}
