import "package:flutter/material.dart";

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
