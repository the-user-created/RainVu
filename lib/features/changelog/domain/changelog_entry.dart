import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/core/ui/custom_colors.dart";
import "package:rain_wise/l10n/app_localizations.dart";

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
  const factory ChangeItem({
    required final String description,
    @Default(false) final bool isBreaking,
  }) = _ChangeItem;
}
