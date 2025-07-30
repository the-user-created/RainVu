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

/// A modern, styled segmented control widget.
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

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: effectiveBorderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: segments.map((final segment) {
            final bool isSelected = segment.value == selectedValue;
            final bool isEnabled = segment.enabled;

            return Expanded(
              child: InkWell(
                onTap:
                    isEnabled ? () => onSelectionChanged(segment.value) : null,
                splashColor: isEnabled
                    ? colorScheme.secondary.withValues(alpha: 0.2)
                    : Colors.transparent,
                highlightColor: isEnabled
                    ? colorScheme.secondary.withValues(alpha: 0.1)
                    : Colors.transparent,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.secondary : Colors.transparent,
                  ),
                  child: Center(
                    child: DefaultTextStyle(
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: isSelected
                            ? colorScheme.onSecondary
                            : isEnabled
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                      ),
                      child: segment.label,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
