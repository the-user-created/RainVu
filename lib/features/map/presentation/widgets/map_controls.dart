import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    this.onFilterPressed,
    this.onLayersPressed,
    this.onMyLocationPressed,
    this.onZoomInPressed,
    this.onZoomOutPressed,
  });

  final VoidCallback? onFilterPressed;
  final VoidCallback? onLayersPressed;
  final VoidCallback? onMyLocationPressed;
  final VoidCallback? onZoomInPressed;
  final VoidCallback? onZoomOutPressed;

  @override
  Widget build(final BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MapControlButton(
            icon: Icons.filter_list,
            tooltip: "Filter by date",
            onPressed: onFilterPressed,
          ),
          _MapControlButton(
            icon: Icons.layers,
            tooltip: "Change map type",
            onPressed: onLayersPressed,
          ),
          _MapControlButton(
            icon: Icons.my_location,
            tooltip: "Center on my location",
            onPressed: onMyLocationPressed,
          ),
          _MapControlButton(
            icon: Icons.add,
            tooltip: "Zoom in",
            onPressed: onZoomInPressed,
          ),
          _MapControlButton(
            icon: Icons.remove,
            tooltip: "Zoom out",
            onPressed: onZoomOutPressed,
          ),
        ]
            .map(
              (final w) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: w,
              ),
            )
            .toList(),
      );
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Material(
      shape: const CircleBorder(),
      color: theme.primaryBackground,
      elevation: 4,
      shadowColor: Colors.black38,
      child: AppIconButton(
        icon: Icon(icon, size: 24),
        onPressed: onPressed,
        tooltip: tooltip,
        color: theme.primaryText,
      ),
    );
  }
}
