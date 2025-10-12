import "package:flutter/material.dart";
import "package:rain_wise/core/ui/custom_colors.dart";
import "package:rain_wise/features/changelog/domain/changelog_entry.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class ChangeItemTile extends StatelessWidget {
  const ChangeItemTile({required this.item, super.key});

  final ChangeItem item;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 12),
            child: Icon(
              Icons.water_drop_outlined,
              size: 16,
              color: item.isBreaking
                  ? colorScheme.changelogRemoved
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
                children: [
                  if (item.isBreaking)
                    TextSpan(
                      text: "${l10n.changelogBreaking} ",
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.changelogRemoved,
                        height: 1.5,
                      ),
                    ),
                  TextSpan(text: item.description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
