import "package:riverpod_annotation/riverpod_annotation.dart";

part "settings_repository.g.dart";

class SettingsRepository {}

@riverpod
SettingsRepository settingsRepository(final SettingsRepositoryRef ref) =>
    SettingsRepository();
