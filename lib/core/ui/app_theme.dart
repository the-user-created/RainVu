import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

/// Defines the color palettes, text styles, and component themes for the app.
class AppTheme {
  AppTheme._();

  // --- Color Definitions ---
  static const _primary = Color(0xFF36474F);
  static const _secondary = Color(0xFF6995A7);
  static const _tertiary = Color(0xFF14A698);

  // --- Light Mode ColorScheme ---
  static const _lightColorScheme = ColorScheme.light(
    primary: _primary,
    onPrimary: Colors.white,
    secondary: _secondary,
    onSecondary: Colors.white,
    tertiary: _tertiary,
    onTertiary: Colors.white,
    error: Color(0xFFD93C4D),
    onError: Colors.white,
    surface: Color(0xFFFBF9F5),
    onSurface: Color(0xFF171B1E),
    surfaceContainerHighest: Color(0xFFECE7E0),
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
    surface: Color(0xFF171B1E),
    onSurface: Color(0xFFE8E8E8),
    surfaceContainerHighest: Color(0xFF222A30),
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
    final TextTheme textTheme = _buildTextTheme(_baseTextTheme, colorScheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        elevation: 2,
        centerTitle: false,
        scrolledUnderElevation: 1,
        titleTextStyle: textTheme.headlineMedium,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actionsIconTheme: IconThemeData(color: colorScheme.tertiary),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: colorScheme.onSurface),
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
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.2),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surface,
        headerBackgroundColor: colorScheme.secondary,
        headerForegroundColor: colorScheme.onSecondary,
        headerHelpStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSecondary,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondary;
          }
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onSecondary;
          }
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          return colorScheme.onSurface;
        }),
        dayShape: WidgetStateProperty.all(const CircleBorder()),
        yearBackgroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondary;
          }
          return Colors.transparent;
        }),
        yearForegroundColor: WidgetStateProperty.resolveWith((final states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onSecondary;
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
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.tertiary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: false,
        dragHandleColor: colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.tertiary,
        foregroundColor: colorScheme.onTertiary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionTextColor: colorScheme.tertiary,
        elevation: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        elevation: 4,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        deleteIconColor: colorScheme.onSurface,
        disabledColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        selectedColor: colorScheme.secondary,
        secondarySelectedColor: colorScheme.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSecondary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        elevation: 0,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.surface),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(4),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
        textStyle: textTheme.bodyLarge,
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
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        activeTrackColor: colorScheme.secondary,
        inactiveTrackColor: colorScheme.secondary.withValues(alpha: 0.3),
        thumbColor: colorScheme.secondary,
        overlayColor: colorScheme.secondary.withValues(alpha: 0.2),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: colorScheme.secondary,
        valueIndicatorTextStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSecondary,
        ),
      ),
    );
  }
}
