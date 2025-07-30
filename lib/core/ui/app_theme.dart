import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

/// Defines the color palettes, text styles, and component themes for the app.
class AppTheme {
  AppTheme._();

  // --- Color Definitions from FlutterFlowTheme ---
  static const _primary = Color(0xFF36474F);
  static const _secondary = Color(0xFF6995A7);
  static const _tertiary = Color(0xFF14A698);

  // --- Light Mode ColorScheme ---
  static const _lightColorScheme = ColorScheme.light(
    primary: _primary,
    secondary: _secondary,
    onSecondary: Colors.white,
    tertiary: _tertiary,
    onTertiary: Colors.white,
    error: Color(0xFFD93C4D),
    background: Color(0xFFFBF9F5),
    onBackground: Color(0xFF171B1E),
    onSurface: Color(0xFF171B1E),
    surfaceVariant: Color(0xFFECE7E0),
    onSurfaceVariant: Color(0xFF58636A),
    outline: Color(0xFFBABCBD),
  );

  // --- Dark Mode ColorScheme ---
  static const _darkColorScheme = ColorScheme.dark(
    primary: _primary,
    onPrimary: Colors.white,
    secondary: _secondary,
    onSecondary: Colors.white,
    tertiary: _tertiary,
    onTertiary: Colors.white,
    error: Color(0xFFD93C4D),
    onError: Colors.white,
    background: Color(0xFF1E252A),
    surface: Color(0xFF171B1E),
    surfaceVariant: Color(0xFF222A30),
    onSurfaceVariant: Color(0xFF949FA9),
    outline: Color(0xFF182126),
  );

  // --- Base TextTheme with Font sizes and weights ---
  static TextTheme get _baseTextTheme => const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 64),
        displayMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 44),
        displaySmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 36),
        headlineLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 32),
        headlineMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
        headlineSmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        titleSmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
        labelLarge: TextStyle(fontSize: 16),
        labelMedium: TextStyle(fontSize: 14),
        labelSmall: TextStyle(fontSize: 12),
      );

  // --- Merged & Colored TextThemes ---
  static TextTheme _buildTextTheme(
    final TextTheme base,
    final ColorScheme colorScheme,
  ) {
    // Merges Readex Pro for headlines and Inter for body/label text
    final TextTheme readexTheme = GoogleFonts.readexProTextTheme(base);
    final TextTheme interTheme = GoogleFonts.interTextTheme(base);
    return readexTheme
        .copyWith(
          bodyLarge: interTheme.bodyLarge,
          bodyMedium: interTheme.bodyMedium,
          bodySmall: interTheme.bodySmall,
          labelLarge: interTheme.labelLarge,
          labelMedium: interTheme.labelMedium,
          labelSmall: interTheme.labelSmall,
        )
        .apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        );
  }

  // --- Main ThemeData Definitions ---
  static ThemeData get light => _buildThemeData(_lightColorScheme);

  static ThemeData get dark => _buildThemeData(_darkColorScheme);

  static ThemeData _buildThemeData(final ColorScheme colorScheme) {
    final TextTheme textTheme = _buildTextTheme(
      _baseTextTheme,
      colorScheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: textTheme.headlineMedium,
        iconTheme: IconThemeData(color: colorScheme.onBackground),
        actionsIconTheme: IconThemeData(color: colorScheme.tertiary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          minimumSize: const Size(double.infinity, 50),
          textStyle:
              textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surface,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: colorScheme.onPrimary,
        headerHelpStyle:
            textTheme.headlineSmall?.copyWith(color: colorScheme.onPrimary),
        dayBackgroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          return colorScheme.onSurface;
        }),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colorScheme.surface,
        hourMinuteTextColor: colorScheme.onSurface,
        dialHandColor: colorScheme.primary,
        dayPeriodTextColor: WidgetStateColor.resolveWith(
          (final states) => states.contains(WidgetState.selected)
              ? colorScheme.onPrimary
              : colorScheme.onSurface,
        ),
        dayPeriodColor: WidgetStateColor.resolveWith(
          (final states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : Colors.transparent,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.background,
        selectedItemColor: colorScheme.tertiary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
