import "package:rain_wise/features/monthly_breakdown/data/monthly_breakdown_repository.dart";
import "package:rain_wise/features/monthly_breakdown/domain/monthly_breakdown_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "monthly_breakdown_provider.g.dart";

@riverpod
Future<MonthlyBreakdownData> monthlyBreakdown(
  final MonthlyBreakdownRef ref,
  final DateTime month,
) async {
  final MonthlyBreakdownRepository repo =
      ref.watch(monthlyBreakdownRepositoryProvider);
  return repo.fetchMonthlyBreakdown(month);
}
