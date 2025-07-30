import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

/// Represents a single option for the [AppChoiceChips] widget.
class ChipOption<T> {
  const ChipOption({
    required this.value,
    required this.label,
    this.icon,
  });

  /// The unique value associated with this chip.
  final T value;

  /// The text to display on the chip.
  final String label;

  /// An optional icon to display before the label.
  final IconData? icon;
}

/// A modern, reusable set of choice chips.
///
/// Replaces the standard [ChoiceChip] to provide a consistent, animated, and
/// tappable chip selection experience across the app.
class AppChoiceChips<T> extends StatelessWidget {
  const AppChoiceChips({
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    super.key,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  /// A list of [ChipOption]s to display.
  final List<ChipOption<T>> options;

  /// The currently selected value.
  final T selectedValue;

  /// Callback that is fired when a new chip is selected.
  final ValueChanged<T> onSelected;

  /// The horizontal spacing between chips.
  final double spacing;

  /// The vertical spacing between chip rows.
  final double runSpacing;

  @override
  Widget build(final BuildContext context) => Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children:
            options.map((final option) => _buildChip(context, option)).toList(),
      );

  Widget _buildChip(final BuildContext context, final ChipOption<T> option) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final bool isSelected = selectedValue == option.value;
    final BorderRadius borderRadius = BorderRadius.circular(20);

    return InkWell(
      onTap: () => onSelected(option.value),
      borderRadius: borderRadius,
      splashColor: theme.primary.withValues(alpha: 0.2),
      highlightColor: theme.primary.withValues(alpha: 0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.alternate,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              Icon(
                option.icon,
                size: 18,
                color:
                    isSelected ? theme.secondaryBackground : theme.primaryText,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              option.label,
              style: theme.bodyMedium.override(
                fontFamily: theme.bodyMediumFamily,
                color:
                    isSelected ? theme.secondaryBackground : theme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
