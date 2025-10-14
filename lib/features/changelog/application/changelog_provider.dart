import "package:rainly/features/changelog/data/changelog_repository.dart";
import "package:rainly/features/changelog/domain/changelog_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "changelog_provider.g.dart";

/// Provides the list of changelog releases by parsing the CHANGELOG.md file.
@riverpod
Future<List<ChangelogRelease>> changelog(final Ref ref) =>
    ref.watch(changelogRepositoryProvider).parseChangelog();
