import "package:flutter/material.dart";
import "package:rainvu/features/changelog/domain/changelog_entry.dart";

class ChangeItemTile extends StatelessWidget {
  const ChangeItemTile({required this.item, required this.category, super.key});

  final ChangeItem item;
  final ChangeCategory category;

  /// Parses a string with `**bold**` markdown and returns a list of [TextSpan]s.
  List<TextSpan> _buildTextSpans(
    final String text,
    final TextStyle baseStyle,
    final TextStyle boldStyle,
  ) {
    final List<TextSpan> spans = [];
    final RegExp boldRegex = RegExp(r"\*\*(.*?)\*\*");
    int lastMatchEnd = 0;

    for (final Match match in boldRegex.allMatches(text)) {
      // Add the text before the bold part.
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }
      // Add the bold part.
      spans.add(TextSpan(text: match.group(1), style: boldStyle));
      lastMatchEnd = match.end;
    }

    // Add any remaining text after the last bold part.
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    // If no bold text was found, return a single span.
    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return spans;
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final Color categoryColor = category.color(colorScheme);

    final TextStyle baseStyle = textTheme.bodyMedium!.copyWith(
      color: colorScheme.onSurfaceVariant,
      height: 1.5,
    );
    final TextStyle boldStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 12),
            child: Icon(category.icon, size: 18, color: categoryColor),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: baseStyle,
                children: _buildTextSpans(
                  item.description,
                  baseStyle,
                  boldStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
