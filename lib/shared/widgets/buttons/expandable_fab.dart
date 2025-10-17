import "package:flutter/material.dart";

/// A data class for actions in the [ExpandableFab].
@immutable
class ActionButton {
  const ActionButton({required this.onPressed, required this.icon, this.label});

  final VoidCallback onPressed;
  final Widget icon;
  final String? label;
}

/// An expandable floating action button that displays multiple actions
/// with a smooth, staggered animation.
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    required this.children,
    super.key,
    this.initialOpen = false,
    this.distance = 60.0,
  });

  /// Whether the FAB is open initially.
  final bool initialOpen;

  /// The distance between each action button.
  final double distance;

  /// The list of [ActionButton]s to display.
  final List<ActionButton> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  List<Widget> _buildExpandingActionButtons() {
    final List<Widget> buttons = [];
    final int count = widget.children.length;
    const double staggerFraction = 0.6;
    final double step = 1.0 / count;

    for (int i = 0; i < count; i++) {
      final double start = (count - 1 - i) * (step * staggerFraction);
      final double end = start + (1.0 - (count - 1) * (step * staggerFraction));

      buttons.add(
        _ExpandingActionButton(
          distance: widget.distance * (i + 1),
          progress: CurvedAnimation(
            parent: _expandAnimation,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
          onPressed: () {
            _toggle(); // Close the FAB when an action is tapped
            widget.children[i].onPressed();
          },
          child: widget.children[i],
        ),
      );
    }
    return buttons;
  }

  @override
  Widget build(final BuildContext context) => SizedBox.expand(
    child: Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        // Transparent overlay to enable tap-away-to-close
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: Container(color: Colors.transparent),
            ),
          ),
        ..._buildExpandingActionButtons(),
        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _expandAnimation,
          ),
        ),
      ],
    ),
  );
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.distance,
    required this.progress,
    required this.child,
    required this.onPressed,
  });

  final double distance;
  final Animation<double> progress;
  final ActionButton child;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AnimatedBuilder(
      animation: progress,
      builder: (final context, final _) {
        final double offset = progress.value * distance;
        return Positioned(
          right: 4,
          bottom: 4 + offset,
          child: Opacity(
            opacity: progress.value,
            child: Transform.scale(
              scale: progress.value,
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: onPressed,
                behavior: HitTestBehavior.opaque,
                child: ColoredBox(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (child.label != null)
                        IgnorePointer(
                          child: Material(
                            elevation: 2,
                            color: theme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Text(
                                child.label!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      IgnorePointer(
                        child: FloatingActionButton.small(
                          heroTag: null,
                          // onPressed is handled by the parent GestureDetector
                          onPressed: () {},
                          child: child.icon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
