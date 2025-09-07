import "package:flutter/material.dart";

/// A data model for a single informational item displayed in the [InfoSheet].
class InfoSheetItem {
  const InfoSheetItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  /// The icon to display next to the title.
  final IconData icon;

  /// The title of the informational item. Can be empty if the sheet's main title is sufficient.
  final String title;

  /// The detailed description of the item.
  final String description;
}

/// A reusable, styled bottom sheet for displaying informational content.
///
/// It presents a list of [InfoSheetItem]s in a clean, readable format.
class InfoSheet extends StatelessWidget {
  const InfoSheet({
    required this.title,
    required this.items,
    super.key,
  });

  /// The main title of the bottom sheet.
  final String title;

  /// The list of items to display.
  final List<InfoSheetItem> items;

  /// A convenience method to show the [InfoSheet] as a modal bottom sheet.
  static Future<void> show(
    final BuildContext context, {
    required final String title,
    required final List<InfoSheetItem> items,
  }) async =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (final context) => InfoSheet(title: title, items: items),
      );

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Divider(color: colorScheme.outline.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (final context, final index) {
                  final InfoSheetItem item = items[index];
                  return _InfoListItem(item: item);
                },
                separatorBuilder: (final context, final index) =>
                    const SizedBox(height: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A private widget to render a single item within the [InfoSheet].
class _InfoListItem extends StatelessWidget {
  const _InfoListItem({required this.item});

  final InfoSheetItem item;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: colorScheme.secondaryContainer,
          child: Icon(
            item.icon,
            color: colorScheme.onSecondaryContainer,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.title.isNotEmpty) ...[
                Text(
                  item.title,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
              ],
              Text(
                item.description,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
