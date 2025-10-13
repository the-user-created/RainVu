import "package:flutter/material.dart";

/// A placeholder for a line of text.
class LinePlaceholder extends StatelessWidget {
  const LinePlaceholder({
    required this.height,
    super.key,
    this.width = double.infinity,
    this.color,
    this.borderRadius,
  });

  final double height;
  final double width;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  Widget build(final BuildContext context) => Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: borderRadius ?? BorderRadius.circular(4),
    ),
  );
}

/// A placeholder for a generic card.
class CardPlaceholder extends StatelessWidget {
  const CardPlaceholder({
    required this.height,
    super.key,
    this.width = double.infinity,
    this.child,
  });

  final double height;
  final double width;
  final Widget? child;

  @override
  Widget build(final BuildContext context) => Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.all(16),
    child: child,
  );
}

/// A placeholder for a dropdown form field.
class DropdownPlaceholder extends StatelessWidget {
  const DropdownPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const LinePlaceholder(height: 14, width: 100, color: Colors.white),
          Icon(Icons.expand_more, color: theme.colorScheme.secondary),
        ],
      ),
    );
  }
}
