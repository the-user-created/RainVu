import "package:rain_wise/features/settings/domain/faq.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "settings_repository.g.dart";

class SettingsRepository {
  Future<List<Faq>> getFaqs() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const [
      Faq(
        question: "How do I add a new rain gauge?",
        answer:
            'Go to the Settings tab, tap on "Manage Rain Gauges", and then use the "+" button at the bottom to add a new gauge. Fill in the details and save.',
      ),
      Faq(
        question: "How do I export my rainfall data?",
        answer:
            "Navigate to Settings > Data Export/Import. From there, you can choose your desired format (CSV, PDF, JSON) and export your complete rainfall history.",
      ),
      Faq(
        question: "How do I set up notifications?",
        answer:
            'In the Settings tab, select "Notifications". You can enable or disable daily reminders, set the reminder time, and toggle other alerts like weekly summaries.',
      ),
    ];
  }
}

@riverpod
SettingsRepository settingsRepository(final SettingsRepositoryRef ref) =>
    SettingsRepository();
