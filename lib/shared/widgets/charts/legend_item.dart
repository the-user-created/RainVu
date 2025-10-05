import "package:flutter/material.dart";

enum LegendShape { circle, square }

class LegendItem extends StatelessWidget {
  const LegendItem({
    required this.color,
    required this.text,
    this.shape = LegendShape.square,
    super.key,
  });

  final Color color;
  final String text;
  final LegendShape shape;

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: shape == LegendShape.circle
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              borderRadius: shape == LegendShape.square
                  ? BorderRadius.circular(2)
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(text, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
