import "package:flutter/material.dart";
import "package:rain_wise/core/ui/custom_colors.dart";
import "package:rain_wise/features/settings/domain/changelog_entry.dart";
import "package:rain_wise/features/settings/presentation/widgets/changelog/change_item_tile.dart";

class ChangeGroupWidget extends StatelessWidget {
  const ChangeGroupWidget({required this.group, super.key});

  final ChangeGroup group;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color categoryColor = group.category.color(colorScheme);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.changelogCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: categoryColor, width: 6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: categoryColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                group.category.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: group.items.map(
                    (final item) => ChangeItemTile(item: item),
                  ),
                  color: colorScheme.changelogDivider,
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
