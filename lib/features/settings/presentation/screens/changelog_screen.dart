import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/settings/application/settings_providers.dart";
import "package:rain_wise/features/settings/domain/changelog_entry.dart";
import "package:rain_wise/features/settings/presentation/widgets/changelog/change_group_widget.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class ChangelogScreen extends ConsumerWidget {
  const ChangelogScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<ChangelogRelease> releases = ref.watch(changelogProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.changelogTitle, style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: releases.isEmpty
            ? Center(child: Text(l10n.changelogError))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: releases.length,
                separatorBuilder: (final context, final index) =>
                    const SizedBox(height: 24),
                itemBuilder: (final context, final index) {
                  final ChangelogRelease release = releases[index];
                  return _ReleaseEntryWidget(release: release);
                },
              ),
      ),
    );
  }
}

class _ReleaseEntryWidget extends StatelessWidget {
  const _ReleaseEntryWidget({required this.release});

  final ChangelogRelease release;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "Version ${release.version}",
                style: textTheme.headlineSmall,
              ),
              Text(
                release.date,
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        ...release.changeGroups.map(
          (final group) => ChangeGroupWidget(group: group),
        ),
      ],
    );
  }
}
