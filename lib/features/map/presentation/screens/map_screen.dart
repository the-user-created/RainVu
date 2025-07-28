import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/features/map/presentation/widgets/location_search_bar.dart";
import "package:rain_wise/features/map/presentation/widgets/map_controls.dart";
import "package:rain_wise/features/map/presentation/widgets/map_view.dart";
import "package:rain_wise/features/map/presentation/widgets/recent_rainfall_panel.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) =>
      GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          body: Stack(
            children: [
              const MapView(),

              // Search Bar
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horiEdgePadding,
                ),
                child: LocationSearchBar(),
              ),

              // Map Controls
              Positioned(
                top: 150,
                right: AppConstants.horiEdgePadding - 8,
                child: MapControls(
                  onFilterPressed: () => debugPrint("Filter button pressed"),
                  onLayersPressed: () => debugPrint("Layers button pressed"),
                  onMyLocationPressed: () =>
                      debugPrint("Location button pressed"),
                  onZoomInPressed: () => debugPrint("Zoom in pressed"),
                  onZoomOutPressed: () => debugPrint("Zoom out pressed"),
                ),
              ),

              // Recent Rainfall Panel
              const Align(
                alignment: Alignment.bottomCenter,
                child: RecentRainfallPanel(),
              ),
            ],
          ),
        ),
      );
}
