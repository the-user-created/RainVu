import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/ui/custom_colors.dart";
import "package:rain_wise/features/settings/application/settings_providers.dart";
import "package:rain_wise/features/settings/domain/changelog_entry.dart";
import "package:rain_wise/features/settings/presentation/widgets/changelog/change_group_widget.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class ChangelogScreen extends ConsumerWidget {
  const ChangelogScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<ChangelogRelease> releases = ref.watch(changelogProvider);

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
        child: releases.isEmpty
            ? Center(child: Text(l10n.changelogError))
            : ListView.separated(
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
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.changelogVersion(release.version),
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.85),
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
