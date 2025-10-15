import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/ui/custom_colors.dart";
import "package:rainvu/features/changelog/application/changelog_provider.dart";
import "package:rainvu/features/changelog/domain/changelog_entry.dart";
import "package:rainvu/features/changelog/presentation/widgets/change_group_widget.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/widgets/placeholders.dart";

class ChangelogScreen extends ConsumerWidget {
  const ChangelogScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<ChangelogRelease>> releasesAsync = ref.watch(
      changelogProvider,
    );

    return Scaffold(
      backgroundColor: colorScheme.changelogBackground,
      appBar: AppBar(
        title: Text(l10n.changelogTitle, style: theme.textTheme.titleLarge),
        backgroundColor: colorScheme.changelogBackground,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: releasesAsync.when(
          loading: () => const _ChangelogLoadingPlaceholder(),
          error: (final error, final stackTrace) {
            FirebaseCrashlytics.instance.recordError(
              error,
              stackTrace,
              reason: "Failed to parse CHANGELOG.md",
            );
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.changelogError,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          data: (final releases) {
            if (releases.isEmpty) {
              return Center(child: Text(l10n.changelogError));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: releases.length,
              separatorBuilder: (final context, final index) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 32,
                ),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.changelogDivider,
                ),
              ),
              itemBuilder: (final context, final index) {
                final ChangelogRelease release = releases[index];
                return _ReleaseEntryWidget(release: release);
              },
            );
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
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.changelogVersion(release.version),
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                release.date,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        ...release.changeGroups.map(
          (final group) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ChangeGroupWidget(group: group),
          ),
        ),
      ],
    );
  }
}

class _ChangelogLoadingPlaceholder extends StatelessWidget {
  const _ChangelogLoadingPlaceholder();

  @override
  Widget build(final BuildContext context) {
    final Color color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: List.generate(
        3,
        (final index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinePlaceholder(height: 36, width: 150, color: color),
                  const SizedBox(height: 8),
                  LinePlaceholder(height: 20, width: 100, color: color),
                ],
              ),
            ),
            CardPlaceholder(height: 120, color: color),
            const SizedBox(height: 12),
            CardPlaceholder(height: 80, color: color),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
