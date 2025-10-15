import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rainvu/core/firebase/analytics_service.dart";
import "package:rainvu/l10n/app_localizations.dart";

/// A Scaffold with a persistent BottomNavigationBar for nested navigation.
///
/// This widget is used as the `builder` for the `StatefulShellRoute`.
/// It displays the `navigationShell` as its body and handles tab switching
/// via the `goBranch` method.
class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  String _getScreenNameForIndex(final int index) {
    switch (index) {
      case 0:
        return "home";
      case 1:
        return "insights";
      case 2:
        return "gauges";
      case 3:
        return "settings";
      default:
        return "unknown_shell_route";
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        // Set the current index from the navigation shell
        currentIndex: navigationShell.currentIndex,
        // Navigate to the selected branch when a tab is tapped
        onTap: (final index) {
          // Only log a screen view if the user is switching to a different tab.
          if (index != navigationShell.currentIndex) {
            final String screenName = _getScreenNameForIndex(index);
            // Use ref.read for one-off actions inside callbacks.
            ref
                .read(analyticsServiceProvider)
                .logScreenView(screenName: screenName);
          }

          // Use goBranch to switch tabs while preserving stack state
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _AnimatedNavIcon(
              icon: Icons.home,
              isSelected: navigationShell.currentIndex == 0,
            ),
            label: l10n.navHome,
            tooltip: l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: _AnimatedNavIcon(
              icon: Icons.insights,
              isSelected: navigationShell.currentIndex == 1,
            ),
            label: l10n.navInsights,
            tooltip: l10n.navInsights,
          ),
          BottomNavigationBarItem(
            icon: _AnimatedNavIcon(
              icon: Icons.straighten,
              isSelected: navigationShell.currentIndex == 2,
            ),
            label: l10n.navGauges,
            tooltip: l10n.navGauges,
          ),
          BottomNavigationBarItem(
            icon: _AnimatedNavIcon(
              icon: Icons.settings_rounded,
              isSelected: navigationShell.currentIndex == 3,
            ),
            label: l10n.navSettings,
            tooltip: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}

class _AnimatedNavIcon extends StatefulWidget {
  const _AnimatedNavIcon({required this.icon, required this.isSelected});

  final IconData icon;
  final bool isSelected;

  @override
  State<_AnimatedNavIcon> createState() => _AnimatedNavIconState();
}

class _AnimatedNavIconState extends State<_AnimatedNavIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Set initial state based on selection
    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(final _AnimatedNavIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) =>
      ScaleTransition(scale: _scaleAnimation, child: Icon(widget.icon));
}
