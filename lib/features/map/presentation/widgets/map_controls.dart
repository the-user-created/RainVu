import "package:flutter/material.dart";
import "package:rain_wise/l10n/app_localizations.dart";
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
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MapControlButton(
          icon: Icons.filter_list,
          tooltip: l10n.map_filterListTooltip,
          onPressed: onFilterPressed,
        ),
        _MapControlButton(
          icon: Icons.layers,
          tooltip: l10n.map_layersTooltip,
          onPressed: onLayersPressed,
        ),
        _MapControlButton(
          icon: Icons.my_location,
          tooltip: l10n.map_myLocationTooltip,
          onPressed: onMyLocationPressed,
        ),
        _MapControlButton(
          icon: Icons.add,
          tooltip: l10n.map_zoomInTooltip,
          onPressed: onZoomInPressed,
        ),
        _MapControlButton(
          icon: Icons.remove,
          tooltip: l10n.map_zoomOutTooltip,
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
    final ThemeData theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      color: theme.colorScheme.surface,
      elevation: 4,
      shadowColor: theme.shadowColor,
      child: AppIconButton(
        icon: Icon(icon, size: 24),
        onPressed: onPressed,
        tooltip: tooltip,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
