import "package:rainly/l10n/app_localizations.dart";

enum Season { spring, summer, autumn, winter }

enum Hemisphere { northern, southern }

extension SeasonExtension on Season {
  String getName(final AppLocalizations l10n) {
    switch (this) {
      case Season.spring:
        return l10n.seasonSpring;
      case Season.summer:
        return l10n.seasonSummer;
      case Season.autumn:
        return l10n.seasonAutumn;
      case Season.winter:
        return l10n.seasonWinter;
    }
  }
}

/// Returns the list of months for a given season and hemisphere based on
/// meteorological definitions.
List<int> getMonthsForSeason(final Season season, final Hemisphere hemisphere) {
  if (hemisphere == Hemisphere.northern) {
    switch (season) {
      case Season.spring:
        return [3, 4, 5]; // Mar, Apr, May
      case Season.summer:
        return [6, 7, 8]; // Jun, Jul, Aug
      case Season.autumn:
        return [9, 10, 11]; // Sep, Oct, Nov
      case Season.winter:
        return [12, 1, 2]; // Dec, Jan, Feb
    }
  } else {
    // Southern Hemisphere
    switch (season) {
      case Season.spring:
        return [9, 10, 11]; // Sep, Oct, Nov
      case Season.summer:
        return [12, 1, 2]; // Dec, Jan, Feb
      case Season.autumn:
        return [3, 4, 5]; // Mar, Apr, May
      case Season.winter:
        return [6, 7, 8]; // Jun, Jul, Aug
    }
  }
}

/// Determines the current season based on the device's date and hemisphere.
Season getCurrentSeason(final Hemisphere hemisphere) {
  final int month = DateTime.now().month;
  final Map<int, Season> northernSeasons = {
    1: Season.winter,
    2: Season.winter,
    3: Season.spring,
    4: Season.spring,
    5: Season.spring,
    6: Season.summer,
    7: Season.summer,
    8: Season.summer,
    9: Season.autumn,
    10: Season.autumn,
    11: Season.autumn,
    12: Season.winter,
  };
  final Map<int, Season> southernSeasons = {
    1: Season.summer,
    2: Season.summer,
    3: Season.autumn,
    4: Season.autumn,
    5: Season.autumn,
    6: Season.winter,
    7: Season.winter,
    8: Season.winter,
    9: Season.spring,
    10: Season.spring,
    11: Season.spring,
    12: Season.summer,
  };

  return hemisphere == Hemisphere.northern
      ? northernSeasons[month]!
      : southernSeasons[month]!;
}
