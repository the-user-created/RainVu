import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/services.dart" show rootBundle;
import "package:rain_wise/features/changelog/domain/changelog_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "changelog_repository.g.dart";

/// A repository responsible for fetching and parsing the changelog file.
class ChangelogRepository {
  /// Loads the `CHANGELOG.md` from assets and parses it into a list of
  /// [ChangelogRelease] objects.
  Future<List<ChangelogRelease>> parseChangelog() async {
    try {
      final String content = await rootBundle.loadString("CHANGELOG.md");
      final List<String> lines = content.split("\n");
      final List<ChangelogRelease> releases = [];

      ChangelogRelease? currentRelease;
      ChangeGroup? currentGroup;

      final releaseRegex = RegExp(r"^## \[(.+)\] - (.+)$");
      final categoryRegex = RegExp(r"^### (.+)$");
      final itemRegex = RegExp(r"^- (.+)$");

      for (final String line in lines) {
        final RegExpMatch? releaseMatch = releaseRegex.firstMatch(line);
        if (releaseMatch != null) {
          if (currentRelease != null) {
            if (currentGroup != null) {
              currentRelease = currentRelease.copyWith(
                changeGroups: [...currentRelease.changeGroups, currentGroup],
              );
            }
            releases.add(currentRelease);
          }
          currentRelease = ChangelogRelease(
            version: releaseMatch.group(1)!,
            date: releaseMatch.group(2)!,
            changeGroups: [],
          );
          currentGroup = null; // Reset group for the new release
          continue;
        }

        final RegExpMatch? categoryMatch = categoryRegex.firstMatch(line);
        if (categoryMatch != null && currentRelease != null) {
          if (currentGroup != null) {
            currentRelease = currentRelease.copyWith(
              changeGroups: [...currentRelease.changeGroups, currentGroup],
            );
          }
          final ChangeCategory? category = _parseCategory(
            categoryMatch.group(1)!,
          );
          if (category != null) {
            currentGroup = ChangeGroup(category: category, items: []);
          } else {
            currentGroup = null; // Ignore unknown categories
          }
          continue;
        }

        final RegExpMatch? itemMatch = itemRegex.firstMatch(line);
        if (itemMatch != null && currentGroup != null) {
          String description = itemMatch.group(1)!;

          // Strip out links and author info for simplicity, as they are not modeled.
          description = description
              .replaceAll(RegExp(r"\s*\(.+\)$"), "")
              .trim();

          currentGroup = currentGroup.copyWith(
            items: [
              ...currentGroup.items,
              ChangeItem(description: description),
            ],
          );
        }
      }

      // Add the last parsed release
      if (currentRelease != null) {
        if (currentGroup != null) {
          currentRelease = currentRelease.copyWith(
            changeGroups: [...currentRelease.changeGroups, currentGroup],
          );
        }
        releases.add(currentRelease);
      }

      return releases;
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to load or parse CHANGELOG.md",
      );
      rethrow;
    }
  }

  ChangeCategory? _parseCategory(final String categoryString) {
    switch (categoryString.trim().toLowerCase()) {
      case "added":
        return ChangeCategory.added;
      case "changed":
        return ChangeCategory.changed;
      case "fixed":
        return ChangeCategory.fixed;
      case "removed":
        return ChangeCategory.removed;
      default:
        return null;
    }
  }
}

@riverpod
ChangelogRepository changelogRepository(final Ref ref) => ChangelogRepository();
