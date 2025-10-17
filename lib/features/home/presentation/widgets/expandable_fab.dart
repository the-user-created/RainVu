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
    this.distance = 72.0,
  });

  /// Whether the FAB is open initially.
  final bool initialOpen;

  /// The vertical distance between the center of each action button.
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
          distance: widget.distance,
          index: i,
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
          shape: const CircleBorder(),
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
    required this.index,
  });

  final double distance;
  final int index;
  final Animation<double> progress;
  final ActionButton child;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return AnimatedBuilder(
      animation: progress,
      builder: (final context, final _) {
        final double offset = (index + 1) * distance;

        return Positioned(
          right: 0,
          bottom: progress.value * offset,
          child: Opacity(
            opacity: progress.value,
            child: Transform.translate(
              offset: Offset(0, 16 * (1.0 - progress.value)),
              child: Transform.scale(
                scale: progress.value,
                alignment: Alignment.centerRight,
                child: Material(
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  color: colorScheme.tertiary,
                  child: InkWell(
                    onTap: onPressed,
                    splashColor: colorScheme.onTertiary.withValues(alpha: 0.1),
                    highlightColor: colorScheme.onTertiary.withValues(
                      alpha: .05,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (child.label != null) ...[
                            Text(
                              child.label!,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onTertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          IconTheme(
                            data: IconThemeData(
                              color: colorScheme.onTertiary,
                              size: 20,
                            ),
                            child: child.icon,
                          ),
                        ],
                      ),
                    ),
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
