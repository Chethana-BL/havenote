import 'package:flutter/material.dart';
import 'package:havenote/app/constants/app_sizes.dart';

class AppTheme {
  static const seedColor = Color(0xFF4A6572); // muted blue-grey
  // static const seedColor = Color(0xFF5C6BC0); // Soft indigo

  /// Light theme built from the brand seed.
  static ThemeData light() {
    final cs = ColorScheme.fromSeed(seedColor: seedColor);
    return _baseTheme(cs);
  }

  /// Dark theme built from the brand seed.
  static ThemeData dark() {
    final cs = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    return _baseTheme(cs);
  }

  /// Shared component styles for both light & dark.
  static ThemeData _baseTheme(ColorScheme cs) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.padding,
          vertical: AppSizes.spaceSM,
        ),
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          side: BorderSide(color: cs.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
          foregroundColor: cs.primary,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
        elevation: AppSizes.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        ),
      ),

      cardTheme: CardTheme(
        color: cs.surface,
        surfaceTintColor: cs.surfaceTint,
        elevation: AppSizes.elevation,
        margin: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        ),
      ),

      dividerTheme: DividerThemeData(
        thickness: AppSizes.dividerThickness,
        color: cs.outlineVariant,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: cs.secondaryContainer,
        selectedColor: cs.tertiaryContainer,
        labelStyle: TextStyle(color: cs.onSecondaryContainer),
        side: BorderSide(color: cs.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSM),
        ),
      ),
    );
  }
}
