import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/features/monthly_breakdown/data/monthly_breakdown_repository.dart";
import "package:rain_wise/features/monthly_breakdown/domain/monthly_breakdown_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "monthly_breakdown_provider.g.dart";

@riverpod
Future<MonthlyBreakdownData> monthlyBreakdown(
  final Ref ref,
  final DateTime month,
) async {
  ref.watch(rainfallRepositoryProvider).watchTableUpdates();

  final MonthlyBreakdownRepository repo =
      ref.watch(monthlyBreakdownRepositoryProvider);
  return repo.fetchMonthlyBreakdown(month);
}
