import "package:flutter/material.dart";
import "package:rain_wise/features/settings/domain/changelog_entry.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class ChangeItemCard extends StatelessWidget {
  const ChangeItemCard({required this.item, super.key});

  final ChangeItem item;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 12),
              child: Icon(
                Icons.circle,
                size: 8,
                color: item.isBreaking
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  children: [
                    if (item.isBreaking)
                      TextSpan(
                        text: "${l10n.changelogBreaking} ",
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.error,
                        ),
                      ),
                    TextSpan(text: item.description),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
