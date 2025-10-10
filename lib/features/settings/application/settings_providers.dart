import "package:package_info_plus/package_info_plus.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "settings_providers.g.dart";

/// Provider to get app version info from the platform.
@riverpod
Future<PackageInfo> appInfo(final Ref ref) => PackageInfo.fromPlatform();
