import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

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
                padding: const EdgeInsets.symmetric(vertical: 6),
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
    return FloatingActionButton.small(
      heroTag: tooltip,
      // Unique heroTag for each FAB
      onPressed: onPressed,
      backgroundColor: theme.primaryBackground,
      foregroundColor: theme.primaryText,
      elevation: 4,
      tooltip: tooltip,
      shape: const CircleBorder(),
      child: Icon(icon, size: 24),
    );
  }
}
