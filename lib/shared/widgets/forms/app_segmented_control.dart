import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

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
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final BorderRadius effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(12);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: theme.alternate,
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
                    ? theme.primary.withValues(alpha: 0.2)
                    : Colors.transparent,
                highlightColor: isEnabled
                    ? theme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primary : Colors.transparent,
                  ),
                  child: Center(
                    child: DefaultTextStyle(
                      style: theme.bodyMedium.override(
                        fontFamily: theme.bodyMediumFamily,
                        color: isSelected
                            ? theme.primaryBackground
                            : isEnabled
                                ? theme.secondaryText
                                : theme.secondaryText.withValues(alpha: 0.5),
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
