import "package:package_info_plus/package_info_plus.dart";
import "package:rain_wise/features/settings/domain/changelog_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "settings_providers.g.dart";

/// Provider to get app version info from the platform.
@riverpod
Future<PackageInfo> appInfo(final Ref ref) => PackageInfo.fromPlatform();

/// Provides a mock list of changelog releases.
@riverpod
List<ChangelogRelease> changelog(final Ref ref) => [
  const ChangelogRelease(
    version: "1.2.0",
    date: "2024-08-15",
    changeGroups: [
      ChangeGroup(
        category: ChangeCategory.added,
        items: [
          ChangeItem(
            description:
                "New 'What's New' screen to view app updates directly within the settings.",
          ),
          ChangeItem(
            description:
                "Added 'Share RainWise' and 'Leave a Review' options to support development.",
          ),
        ],
      ),
      ChangeGroup(
        category: ChangeCategory.changed,
        items: [
          ChangeItem(
            description:
                "Restructured Settings screen for better organization.",
          ),
          ChangeItem(
            description:
                "Moved App Reset functionality into the 'Help & Feedback' screen.",
          ),
        ],
      ),
      ChangeGroup(
        category: ChangeCategory.fixed,
        items: [
          ChangeItem(
            description:
                "Corrected a minor layout issue on the monthly breakdown chart.",
          ),
        ],
      ),
    ],
  ),
  const ChangelogRelease(
    version: "1.1.0",
    date: "2024-07-20",
    changeGroups: [
      ChangeGroup(
        category: ChangeCategory.changed,
        items: [
          ChangeItem(
            isBreaking: true,
            description:
                "Upgraded charting library, which may affect the appearance of historical data.",
          ),
          ChangeItem(
            description:
                "Improved performance of the Comparative Analysis tool.",
          ),
        ],
      ),
      ChangeGroup(
        category: ChangeCategory.fixed,
        items: [
          ChangeItem(
            description:
                "Resolved an issue where CSV export would fail for very large datasets.",
          ),
          ChangeItem(
            description:
                "Fixed a bug causing the app to crash on startup for some Android 14 devices.",
          ),
        ],
      ),
    ],
  ),
  const ChangelogRelease(
    version: "1.0.0",
    date: "2024-06-01",
    changeGroups: [
      ChangeGroup(
        category: ChangeCategory.added,
        items: [ChangeItem(description: "Initial release of RainWise!")],
      ),
    ],
  ),
];
