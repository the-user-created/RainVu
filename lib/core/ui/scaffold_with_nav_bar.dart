import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/l10n/app_localizations.dart";

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
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.house),
            label: l10n.navHome,
            tooltip: l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.chartLine),
            label: l10n.navInsights,
            tooltip: l10n.navInsights,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.mapLocationDot),
            label: l10n.navMap,
            tooltip: l10n.navMap,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_rounded),
            label: l10n.navSettings,
            tooltip: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
