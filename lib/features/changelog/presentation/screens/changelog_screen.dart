import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
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
      appBar: AppBar(
        title: Text(l10n.changelogTitle, style: theme.textTheme.titleLarge),
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
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: releases.length,
              itemBuilder: (final context, final index) {
                final ChangelogRelease release = releases[index];
                final bool isLast = index == releases.length - 1;
                return _TimelineReleaseEntry(release: release, isLast: isLast);
              },
            );
          },
        ),
      ),
    );
  }
}

class _TimelineReleaseEntry extends StatelessWidget {
  const _TimelineReleaseEntry({required this.release, required this.isLast});

  final ChangelogRelease release;
  final bool isLast;

  @override
  Widget build(final BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TimelineConnector(isLast: isLast),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 32),
            child: _ReleaseEntryWidget(release: release),
          ),
        ),
      ],
    ),
  );
}

class _TimelineConnector extends StatelessWidget {
  const _TimelineConnector({required this.isLast});

  final bool isLast;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            ),
            child: Icon(
              Icons.celebration_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                color: theme.colorScheme.outlineVariant,
              ),
            ),
        ],
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
          padding: const EdgeInsets.only(bottom: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.changelogVersionTag(release.version),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              Text(
                release.date,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      children: List.generate(3, (final index) {
        final bool isLast = index == 2;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TimelineConnector(isLast: isLast),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            LinePlaceholder(
                              height: 28,
                              width: 90,
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            const SizedBox(width: 12),
                            LinePlaceholder(
                              height: 16,
                              width: 100,
                              color: color,
                            ),
                          ],
                        ),
                      ),
                      CardPlaceholder(height: 120, color: color),
                      const SizedBox(height: 12),
                      CardPlaceholder(height: 80, color: color),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
