import "package:flutter/material.dart";

/// Represents a single option for the [AppChoiceChips] widget.
class ChipOption<T> {
  const ChipOption({
    required this.value,
    required this.label,
    this.icon,
    this.semanticsLabel,
  });

  /// The unique value associated with this chip.
  final T value;

  /// The text to display on the chip.
  final String label;

  /// An optional icon to display before the label.
  final IconData? icon;

  /// An optional semantic label for the chip's text, for accessibility.
  final String? semanticsLabel;
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
    this.alignment = WrapAlignment.start,
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

  /// How the chips are aligned in the main axis.
  final WrapAlignment alignment;

  @override
  Widget build(final BuildContext context) => Wrap(
    spacing: spacing,
    runSpacing: runSpacing,
    alignment: alignment,
    children: options
        .map((final option) => _buildChip(context, option))
        .toList(),
  );

  Widget _buildChip(final BuildContext context, final ChipOption<T> option) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final bool isSelected = selectedValue == option.value;
    final BorderRadius borderRadius =
        theme.chipTheme.shape is RoundedRectangleBorder
        ? ((theme.chipTheme.shape! as RoundedRectangleBorder).borderRadius
              as BorderRadius)
        : BorderRadius.circular(20);

    final Color selectedColor = theme.chipTheme.selectedColor!;
    final Color unselectedColor = theme.chipTheme.backgroundColor!;
    final Color selectedForegroundColor =
        theme.chipTheme.secondaryLabelStyle!.color!;
    final Color unselectedForegroundColor = theme.chipTheme.labelStyle!.color!;

    return InkWell(
      onTap: () => onSelected(option.value),
      borderRadius: borderRadius,
      splashColor: selectedColor.withValues(alpha: 0.2),
      highlightColor: selectedColor.withValues(alpha: 0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: theme.chipTheme.padding,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: borderRadius,
          border: Border.fromBorderSide(
            theme.chipTheme.side ?? BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              Icon(
                option.icon,
                size: 18,
                color: isSelected
                    ? selectedForegroundColor
                    : unselectedForegroundColor,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              option.label,
              semanticsLabel: option.semanticsLabel,
              style: textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? selectedForegroundColor
                    : unselectedForegroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
