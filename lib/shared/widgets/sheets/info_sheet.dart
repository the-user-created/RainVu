import "package:flutter/material.dart";
import "package:rain_wise/shared/utils/adaptive_ui_helpers.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

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
  const InfoSheet({required this.items, super.key});

  /// The list of items to display.
  final List<InfoSheetItem> items;

  /// A convenience method to show the [InfoSheet] as a modal bottom sheet.
  static Future<void> show(
    final BuildContext context, {
    required final String title,
    required final List<InfoSheetItem> items,
  }) async => showAdaptiveSheet<void>(
    context: context,
    builder: (final context) => InteractiveSheet(
      title: Text(title),
      titleAlign: TextAlign.start,
      child: InfoSheet(items: items),
    ),
  );

  @override
  Widget build(final BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(),
      const SizedBox(height: 16),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (final context, final index) {
          final InfoSheetItem item = items[index];
          return _InfoListItem(item: item);
        },
        separatorBuilder: (final context, final index) =>
            const SizedBox(height: 20),
      ),
    ],
  );
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
                Text(item.title, style: textTheme.titleMedium),
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
