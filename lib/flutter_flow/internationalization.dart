import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

const _kLocaleStorageKey = "__locale_key__";

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(final BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ["en"];

  static late SharedPreferences _prefs;

  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  static Future storeLocale(final String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);

  static Locale? getStoredLocale() {
    final String? locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();

  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? "${locale}_short"
          : null;

  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(final String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? "";

  String getVariableText({
    final String? enText = "",
  }) =>
      [enText][languageIndex] ?? "";

  static const Set<String> _languagesWithShortCode = {
    "ar",
    "az",
    "ca",
    "cs",
    "da",
    "de",
    "dv",
    "en",
    "es",
    "et",
    "fi",
    "fr",
    "gr",
    "he",
    "hi",
    "hu",
    "it",
    "km",
    "ku",
    "mn",
    "ms",
    "no",
    "pt",
    "ro",
    "ru",
    "rw",
    "sv",
    "th",
    "uk",
    "vi",
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(final Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(final Locale locale) =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(final FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(final Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(final Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(final FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(final Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(final Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(final FFLocalizationsDelegate old) => false;
}

Locale createLocale(final String language) => language.contains("_")
    ? Locale.fromSubtags(
        languageCode: language.split("_").first,
        scriptCode: language.split("_").last,
      )
    : Locale(language);

bool _isSupportedLocale(final Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith("_")
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final Map<String, Map<String, String>> kTranslationsMap =
    <Map<String, Map<String, String>>>[]
        .reduce((final a, final b) => a..addAll(b));
