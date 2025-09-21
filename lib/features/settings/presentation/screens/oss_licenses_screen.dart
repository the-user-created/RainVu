import "package:flutter/material.dart";
import "package:rain_wise/features/settings/presentation/screens/license_detail_screen.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/oss_licenses.dart" as oss;

class OssLicensesScreen extends StatelessWidget {
  const OssLicensesScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    // Sort packages alphabetically for easier navigation
    final List<oss.Package> packages = [...oss.allDependencies]
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ossLicensesTitle),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: packages.length,
        separatorBuilder: (final context, final index) =>
            const SizedBox(height: 8),
        itemBuilder: (final context, final index) {
          final oss.Package package = packages[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (final context) =>
                        LicenseDetailScreen(package: package),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
