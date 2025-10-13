import "package:rain_wise/core/data/providers/data_providers.dart";
import "package:rain_wise/features/insights_dashboard/data/insights_repository.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "insights_providers.g.dart";

/// Manages the currently selected metric on the dashboard.
@riverpod
class DashboardMetricState extends _$DashboardMetricState {
  @override
  DashboardMetric build() => DashboardMetric.mtd;

  // ignore: use_setters_to_change_properties
  void setMetric(final DashboardMetric metric) {
    state = metric;
  }
}

/// Provides all the data needed for the entire insights feature.
@riverpod
Future<InsightsData> dashboardData(final Ref ref) async {
  // This provider will re-fetch when rainfall data changes.
  ref.watch(rainfallTableUpdatesProvider);

  final InsightsRepository repository = ref.watch(insightsRepositoryProvider);
  return repository.getInsightsData();
}

/// A provider that combines the main data with the user's selection
/// to provide only the relevant [MetricData] to the UI.
@riverpod
MetricData? currentMetricData(final Ref ref) {
  final DashboardMetric metric = ref.watch(dashboardMetricStateProvider);
  final InsightsData? data = ref.watch(dashboardDataProvider).value;

  if (data == null) {
    return null;
  }

  return switch (metric) {
    DashboardMetric.mtd => data.mtdData,
    DashboardMetric.ytd => data.ytdData,
    DashboardMetric.last12Months => data.last12MonthsData,
    DashboardMetric.allTime => data.allTimeData,
  };
}
