import "package:flutter/material.dart";
import "package:rainvu/features/changelog/domain/changelog_entry.dart";
import "package:rainvu/features/changelog/presentation/widgets/change_item_tile.dart";
import "package:rainvu/l10n/app_localizations.dart";

class ChangeGroupWidget extends StatelessWidget {
  const ChangeGroupWidget({required this.group, super.key});

  final ChangeGroup group;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final Color categoryColor = group.category.color(colorScheme);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: categoryColor.withValues(alpha: isDark ? 0.25 : 0.15),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              group.category.title(l10n),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: group.items
                  .map(
                    (final item) =>
                        ChangeItemTile(item: item, category: group.category),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
