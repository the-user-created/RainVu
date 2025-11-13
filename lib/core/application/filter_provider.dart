import "package:riverpod_annotation/riverpod_annotation.dart";

part "filter_provider.g.dart";

/// A special constant to represent the 'All Gauges' filter option.
const String allGaugesFilterId = "all";

/// Manages the currently selected gauge filter across the app.
///
/// A value of [allGaugesFilterId] (the default) means data for all gauges
/// should be shown. Otherwise, the string is the ID of a specific gauge.
@riverpod
class SelectedGaugeFilter extends _$SelectedGaugeFilter {
  @override
  String build() => allGaugesFilterId;

  void setGauge(final String gaugeId) {
    state = gaugeId;
  }
}
