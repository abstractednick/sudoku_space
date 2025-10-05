import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/color_constants.dart';
import '../constants/dimension_constants.dart';
import 'custom_colors.dart';

/// Material 3 dark theme for Sudoku Space
class AppTheme {
  /// Get the main dark theme for the app
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: ColorConstants.noobCyan,
      secondary: ColorConstants.proRed,
      surface: ColorConstants.card,
      background: ColorConstants.background,
      error: ColorConstants.error,
      onPrimary: ColorConstants.background,
      onSecondary: ColorConstants.background,
      onSurface: ColorConstants.textWhite,
      onBackground: ColorConstants.textWhite,
      onError: ColorConstants.textWhite,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: ColorConstants.background,
    
    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorConstants.background,
      foregroundColor: ColorConstants.textWhite,
      elevation: DimensionConstants.elevationS,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      color: ColorConstants.card,
      elevation: DimensionConstants.elevationM,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
      ),
      margin: const EdgeInsets.all(DimensionConstants.spacingS),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.noobCyan,
        foregroundColor: ColorConstants.background,
        elevation: DimensionConstants.elevationM,
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstants.spacingL,
          vertical: DimensionConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(
          DimensionConstants.buttonMinWidth,
          DimensionConstants.buttonHeight,
        ),
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConstants.noobCyan,
        side: const BorderSide(color: ColorConstants.noobCyan),
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstants.spacingL,
          vertical: DimensionConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(
          DimensionConstants.buttonMinWidth,
          DimensionConstants.buttonHeight,
        ),
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConstants.noobCyan,
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstants.spacingM,
          vertical: DimensionConstants.spacingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorConstants.noobCyan,
      foregroundColor: ColorConstants.background,
      elevation: DimensionConstants.elevationL,
      shape: CircleBorder(),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorConstants.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.gridLine),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.gridLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.noobCyan, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.error),
      ),
      contentPadding: const EdgeInsets.all(DimensionConstants.spacingM),
      labelStyle: const TextStyle(color: ColorConstants.textGrey),
      hintStyle: const TextStyle(color: ColorConstants.textDarkGrey),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ColorConstants.card,
      selectedItemColor: ColorConstants.noobCyan,
      unselectedItemColor: ColorConstants.textGrey,
      type: BottomNavigationBarType.fixed,
      elevation: DimensionConstants.elevationL,
    ),
    
    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: ColorConstants.card,
      elevation: DimensionConstants.elevationXL,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusL),
      ),
      titleTextStyle: const TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        color: ColorConstants.textGrey,
        fontSize: 16,
      ),
    ),
    
    // Snack Bar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ColorConstants.card,
      contentTextStyle: const TextStyle(color: ColorConstants.textWhite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: DimensionConstants.elevationL,
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: ColorConstants.textGrey,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: ColorConstants.textGrey,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: ColorConstants.textDarkGrey,
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        color: ColorConstants.textWhite,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: ColorConstants.textGrey,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: ColorConstants.textDarkGrey,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
  
  /// Get theme with game mode specific colors
  static ThemeData getThemeForMode(GameMode mode) {
    final baseTheme = darkTheme;
    
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: mode == GameMode.noob ? ColorConstants.noobCyan : ColorConstants.proRed,
        secondary: mode == GameMode.noob ? ColorConstants.proRed : ColorConstants.noobCyan,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mode == GameMode.noob ? ColorConstants.noobCyan : ColorConstants.proRed,
          foregroundColor: ColorConstants.background,
          elevation: DimensionConstants.elevationM,
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionConstants.spacingL,
            vertical: DimensionConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(
            DimensionConstants.buttonMinWidth,
            DimensionConstants.buttonHeight,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: mode == GameMode.noob ? ColorConstants.noobCyan : ColorConstants.proRed,
        foregroundColor: ColorConstants.background,
        elevation: DimensionConstants.elevationL,
        shape: const CircleBorder(),
      ),
    );
  }
}
