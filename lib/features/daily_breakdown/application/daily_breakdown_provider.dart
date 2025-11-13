import "package:rainvu/core/application/filter_provider.dart";
import "package:rainvu/core/data/providers/data_providers.dart";
import "package:rainvu/features/daily_breakdown/data/daily_breakdown_repository.dart";
import "package:rainvu/features/daily_breakdown/domain/daily_breakdown_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "daily_breakdown_provider.g.dart";

@riverpod
Future<DailyBreakdownData> dailyBreakdown(
  final Ref ref,
  final DateTime month,
) async {
  ref.watch(rainfallTableUpdatesProvider);
  final String gaugeId = ref.watch(selectedGaugeFilterProvider);

  final DailyBreakdownRepository repo = ref.watch(
    dailyBreakdownRepositoryProvider,
  );
  return repo.fetchDailyBreakdown(month, gaugeId: gaugeId);
}
