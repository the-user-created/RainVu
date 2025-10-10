import "package:flutter/material.dart";

/// Represents a single option in the [AppSegmentedControl].
class SegmentOption<T> {
  const SegmentOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  /// The value associated with this option.
  final T value;

  /// The widget to display as the label for this option.
  final Widget label;

  /// Whether this option can be selected.
  final bool enabled;
}

/// A modern, styled segmented control widget with a sliding indicator animation.
///
/// Replaces the standard [SegmentedButton] and [ToggleButtons] to provide
/// a consistent look and feel across the app.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.segments,
    required this.selectedValue,
    required this.onSelectionChanged,
    super.key,
    this.height = 44,
    this.borderRadius,
  });

  /// A list of [SegmentOption]s to display.
  final List<SegmentOption<T>> segments;

  /// The currently selected value.
  final T selectedValue;

  /// Callback when a new segment is selected.
  final ValueChanged<T> onSelectionChanged;

  /// The height of the control.
  final double height;

  /// The border radius for the control.
  final BorderRadius? borderRadius;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final BorderRadius effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(12);

    final int selectedIndex = segments.indexWhere(
      (final s) => s.value == selectedValue,
    );

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final double segmentWidth = constraints.maxWidth / segments.length;

        return ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: effectiveBorderRadius,
            ),
            child: Stack(
              children: [
                // Animated sliding bubble
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  left: selectedIndex * segmentWidth,
                  child: Container(
                    height: height,
                    width: segmentWidth,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: effectiveBorderRadius,
                    ),
                  ),
                ),
                // Segment labels and tap detectors
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: segments.map((final segment) {
                    final bool isSelected = segment.value == selectedValue;
                    final bool isEnabled = segment.enabled;

                    return Expanded(
                      child: InkWell(
                        onTap: isEnabled
                            ? () => onSelectionChanged(segment.value)
                            : null,
                        child: Container(
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: isSelected
                                  ? colorScheme.onSecondary
                                  : isEnabled
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.onSurfaceVariant.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                            child: segment.label,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
