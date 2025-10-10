import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/oss_licenses.dart" as oss;

class OssLicensesScreen extends StatefulWidget {
  const OssLicensesScreen({super.key});

  @override
  State<OssLicensesScreen> createState() => _OssLicensesScreenState();
}

class _OssLicensesScreenState extends State<OssLicensesScreen> {
  final Set<int> _animatedIndices = {};

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    // Sort packages alphabetically
    final List<oss.Package> packages = [...oss.allDependencies]
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

    // Group packages by the first letter of their name
    final Map<String, List<oss.Package>> grouped = groupBy<oss.Package, String>(
      packages,
      (final p) => p.name[0].toUpperCase(),
    );

    // Create a flat list with headers (String) and items (Package)
    final List<dynamic> items = [];
    final List<String> sortedKeys = grouped.keys.toList()..sort();
    for (final String key in sortedKeys) {
      items
        ..add(key)
        ..addAll(grouped[key]!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ossLicensesTitle, style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          itemBuilder: (final context, final index) {
            final dynamic item = items[index];
            Widget child;

            if (item is String) {
              child = _LicenseGroupHeader(letter: item);
            } else if (item is oss.Package) {
              final bool isLastOfGroup =
                  (index + 1 == items.length) || (items[index + 1] is String);
              child = _LicenseListItem(
                package: item,
                isLastOfGroup: isLastOfGroup,
              );
            } else {
              child = const SizedBox.shrink();
            }

            if (_animatedIndices.contains(index)) {
              return child;
            }

            _animatedIndices.add(index);

            return child
                .animate()
                .fade(duration: 500.ms)
                .slideY(
                  begin: 0.2,
                  duration: 400.ms,
                  delay: (index * 20).ms,
                  curve: Curves.easeOutCubic,
                );
          },
        ),
      ),
    );
  }
}

class _LicenseGroupHeader extends StatelessWidget {
  const _LicenseGroupHeader({required this.letter});

  final String letter;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        letter,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _LicenseListItem extends StatelessWidget {
  const _LicenseListItem({required this.package, required this.isLastOfGroup});

  final oss.Package package;
  final bool isLastOfGroup;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      children: [
        ListTile(
          title: Text(package.name, style: theme.textTheme.bodyLarge),
          subtitle: Text(
            l10n.ossLicensesVersion(package.version ?? "N/A"),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          onTap: () =>
              LicenseDetailRoute(packageName: package.name).push(context),
        ),
        if (!isLastOfGroup)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, thickness: 0.5),
          ),
      ],
    );
  }
}
