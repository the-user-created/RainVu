import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

/// A Scaffold with a persistent BottomNavigationBar for nested navigation.
///
/// This widget is used as the `builder` for the `StatefulShellRoute`.
/// It displays the `navigationShell` as its body and handles tab switching
/// via the `goBranch` method.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          // Set the current index from the navigation shell
          currentIndex: navigationShell.currentIndex,
          // Navigate to the selected branch when a tab is tapped
          onTap: (final index) {
            // Use goBranch to switch tabs while preserving stack state
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          selectedItemColor: FlutterFlowTheme.of(context).secondary,
          unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house),
              label: "Home",
              tooltip: "Home",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chartLine),
              label: "Insights",
              tooltip: "Insights",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.mapLocationDot),
              label: "Map",
              tooltip: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: "Settings",
              tooltip: "Settings",
            ),
          ],
        ),
      );
}
