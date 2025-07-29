import "dart:ui";

import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

// TODO: Create domain models for forecast data
class ForecastDay {
  const ForecastDay({
    required this.day,
    required this.icon,
    required this.iconColor,
    required this.temperature,
    required this.chanceOfRain,
  });

  final String day;
  final IconData icon;
  final Color iconColor;
  final String temperature;
  final String chanceOfRain;
}

class ForecastCard extends StatelessWidget {
  const ForecastCard({this.isProUser = false, super.key});

  final bool isProUser;

  // TODO: Replace with real data from a provider
  final List<ForecastDay> forecastDays = const [
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

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          colors: [theme.primaryBackground, theme.alternate],
          stops: const [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("7-Day Forecast", style: theme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: isProUser ? 0 : 3,
                  sigmaY: isProUser ? 0 : 3,
                ),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: forecastDays.length,
                  separatorBuilder: (final context, final index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (final context, final index) {
                    final ForecastDay day = forecastDays[index];
                    return _ForecastDayItem(day: day);
                  },
                ),
              ),
            ),
            if (!isProUser) ...[
              const SizedBox(height: 16),
              Text(
                "Upgrade to Pro to unlock 7-day forecast.",
                style: theme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ForecastDayItem extends StatelessWidget {
  const _ForecastDayItem({required this.day});

  final ForecastDay day;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day.day, style: theme.bodySmall),
            Icon(day.icon, color: day.iconColor, size: 32),
            Text(day.temperature, style: theme.bodyMedium),
            Text(
              day.chanceOfRain,
              style: theme.bodySmall.override(
                color: theme.tertiary,
              ),
            ),
          ].divide(const SizedBox(height: 8)),
        ),
      ),
    );
  }
}
