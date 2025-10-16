import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:rainvu/core/ui/custom_colors.dart";
import "package:rainvu/l10n/app_localizations.dart";

part "changelog_entry.freezed.dart";

enum ChangeCategory { changed, added, removed, fixed }

extension ChangeCategoryExtension on ChangeCategory {
  String title(final AppLocalizations l10n) {
    switch (this) {
      case ChangeCategory.changed:
        return l10n.changelogCategoryChanged;
      case ChangeCategory.added:
        return l10n.changelogCategoryAdded;
      case ChangeCategory.removed:
        return l10n.changelogCategoryRemoved;
      case ChangeCategory.fixed:
        return l10n.changelogCategoryFixed;
    }
  }

  Color color(final ColorScheme colorScheme) {
    switch (this) {
      case ChangeCategory.added:
        return colorScheme.changelogAdded;
      case ChangeCategory.changed:
        return colorScheme.changelogChanged;
      case ChangeCategory.fixed:
        return colorScheme.changelogFixed;
      case ChangeCategory.removed:
        return colorScheme.changelogRemoved;
    }
  }

  IconData get icon {
    switch (this) {
      case ChangeCategory.added:
        return Icons.add_circle_outline;
      case ChangeCategory.changed:
        return Icons.sync_alt_outlined;
      case ChangeCategory.fixed:
        return Icons.check_circle_outline;
      case ChangeCategory.removed:
        return Icons.remove_circle_outline;
    }
  }
}

@freezed
abstract class ChangelogRelease with _$ChangelogRelease {
  const factory ChangelogRelease({
    required final String version,
    required final String date,
    required final List<ChangeGroup> changeGroups,
  }) = _ChangelogRelease;
}

@freezed
abstract class ChangeGroup with _$ChangeGroup {
  const factory ChangeGroup({
    required final ChangeCategory category,
    required final List<ChangeItem> items,
  }) = _ChangeGroup;
}

@freezed
abstract class ChangeItem with _$ChangeItem {
  const factory ChangeItem({required final String description}) = _ChangeItem;
}
