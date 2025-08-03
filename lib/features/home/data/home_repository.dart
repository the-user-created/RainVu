import "package:flutter/foundation.dart" show kDebugMode;
import "package:flutter/material.dart";
import "package:rain_wise/features/home/domain/forecast.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "home_repository.g.dart";

abstract class HomeRepository {
  Future<HomeData> getHomeData();

  Future<List<RainGauge>> getUserGauges();

  Future<List<ForecastDay>> getForecast();

  Future<void> saveRainfallEntry({
    required final String gaugeId,
    required final double amount,
    required final String unit,
    required final DateTime date,
  });
}

@Riverpod(keepAlive: true)
HomeRepository homeRepository(final HomeRepositoryRef ref) =>
    MockHomeRepository();

class MockHomeRepository implements HomeRepository {
  @override
  Future<HomeData> getHomeData() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return const HomeData(
      currentMonth: "July 2024",
      monthlyTotal: "78.5 mm",
      recentEntries: [
        RecentEntry(dateLabel: "Today, 9:15 AM", amount: "12.5 mm"),
        RecentEntry(dateLabel: "Yesterday, 8:30 AM", amount: "8.2 mm"),
        RecentEntry(dateLabel: "July 12, 7:45 AM", amount: "15.3 mm"),
      ],
      quickStats: [
        QuickStat(value: "36.2", label: "mm this week"),
        QuickStat(value: "78.5", label: "mm this month"),
        QuickStat(value: "5.6", label: "mm daily avg"),
      ],
    );
  }

  @override
  Future<List<RainGauge>> getUserGauges() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const [
      RainGauge(id: "gauge_1", name: "Backyard Gauge"),
      RainGauge(id: "gauge_2", name: "Farm - Field A"),
      RainGauge(id: "gauge_3", name: "Rooftop Collector"),
    ];
  }

  @override
  Future<List<ForecastDay>> getForecast() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      ForecastDay(
        day: "Today",
        icon: Icons.wb_sunny,
        iconColor: Color(0xFFFFC107),
        temperature: "24°C",
        chanceOfRain: "10%",
      ),
      ForecastDay(
        day: "Tue",
        icon: Icons.cloud,
        iconColor: Color(0xFF90A4AE),
        temperature: "22°C",
        chanceOfRain: "30%",
      ),
      ForecastDay(
        day: "Wed",
        icon: Icons.grain,
        iconColor: Color(0xFF6995A7),
        temperature: "20°C",
        chanceOfRain: "80%",
      ),
      ForecastDay(
        day: "Thu",
        icon: Icons.wb_cloudy,
        iconColor: Color(0xFF90A4AE),
        temperature: "23°C",
        chanceOfRain: "20%",
      ),
    ];
  }

  @override
  Future<void> saveRainfallEntry({
    required final String gaugeId,
    required final double amount,
    required final String unit,
    required final DateTime date,
  }) async {
    if (kDebugMode) {
      debugPrint(
        "Saving entry: Gauge $gaugeId, $amount $unit on ${date.toIso8601String()}",
      );
    }
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}
