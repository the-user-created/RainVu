import "package:rain_wise/features/insights/data/insights_repository.dart";
import "package:rain_wise/features/insights/domain/insights_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "insights_providers.g.dart";

@riverpod
Future<InsightsData> insightsScreenData(final InsightsScreenDataRef ref) async {
  final InsightsRepository repository = ref.watch(insightsRepositoryProvider);
  return repository.getInsightsData();
}
