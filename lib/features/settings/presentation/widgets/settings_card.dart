import "package:flutter/material.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

/// A styled card that wraps a list of setting tiles.
/// It provides a consistent background, shadow, and dividers.
class SettingsCard extends StatelessWidget {
  const SettingsCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horiEdgePadding,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shadowColor: const Color(0x33000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: theme.primaryBackground,
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ListTile.divideTiles(
            context: context,
            tiles: children,
            color: theme.alternate,
          ).toList(),
        ),
      ),
    );
  }
}
