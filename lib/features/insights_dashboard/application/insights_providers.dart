import "package:rain_wise/core/data/providers/data_providers.dart";
import "package:rain_wise/features/insights_dashboard/data/insights_repository.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "insights_providers.g.dart";

@riverpod
Future<InsightsData> insightsScreenData(final Ref ref) async {
  ref.watch(rainfallTableUpdatesProvider);

  final InsightsRepository repository = ref.watch(insightsRepositoryProvider);
  return repository.getInsightsData();
}
