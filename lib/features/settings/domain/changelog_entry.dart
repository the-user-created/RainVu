import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "changelog_entry.freezed.dart";

enum ChangeCategory { changed, added, removed, fixed }

extension ChangeCategoryExtension on ChangeCategory {
  String get title {
    switch (this) {
      case ChangeCategory.changed:
        return "Changed";
      case ChangeCategory.added:
        return "Added";
      case ChangeCategory.removed:
        return "Removed";
      case ChangeCategory.fixed:
        return "Fixed";
    }
  }

  Color get color {
    switch (this) {
      case ChangeCategory.added:
        return Colors.green.shade600;
      case ChangeCategory.changed:
        return Colors.orange.shade700;
      case ChangeCategory.fixed:
        return Colors.blue.shade600;
      case ChangeCategory.removed:
        return Colors.red.shade600;
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
