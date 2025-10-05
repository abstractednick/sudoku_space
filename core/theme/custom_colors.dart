import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

/// Game mode enumeration
enum GameMode {
  noob,
  pro,
  beast,
}

/// Custom colors and styling for different game modes
class CustomColors {
  /// Get primary color for the given game mode
  static Color getPrimaryColor(GameMode mode) {
    switch (mode) {
      case GameMode.noob:
        return ColorConstants.noobCyan;
      case GameMode.pro:
      case GameMode.beast:
        return ColorConstants.proRed;
    }
  }
  
  /// Get secondary color for the given game mode
  static Color getSecondaryColor(GameMode mode) {
    switch (mode) {
      case GameMode.noob:
        return ColorConstants.proRed;
      case GameMode.pro:
      case GameMode.beast:
        return ColorConstants.noobCyan;
    }
  }
  
  /// Get accent color for the given game mode
  static Color getAccentColor(GameMode mode) {
    switch (mode) {
      case GameMode.noob:
        return ColorConstants.accent;
      case GameMode.pro:
        return ColorConstants.warning;
      case GameMode.beast:
        return ColorConstants.error;
    }
  }
  
  /// Get gradient colors for the given game mode
  static List<Color> getGradientColors(GameMode mode) {
    switch (mode) {
      case GameMode.noob:
        return [
          ColorConstants.noobCyan.withOpacity(0.8),
          ColorConstants.accent.withOpacity(0.6),
          ColorConstants.background,
        ];
      case GameMode.pro:
        return [
          ColorConstants.proRed.withOpacity(0.8),
          ColorConstants.warning.withOpacity(0.6),
          ColorConstants.background,
        ];
      case GameMode.beast:
        return [
          ColorConstants.error.withOpacity(0.9),
          ColorConstants.proRed.withOpacity(0.7),
          ColorConstants.background,
        ];
    }
  }
  
  /// Get linear gradient for the given game mode
  static LinearGradient getLinearGradient(GameMode mode) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: getGradientColors(mode),
      stops: const [0.0, 0.7, 1.0],
    );
  }
  
  /// Get radial gradient for the given game mode
  static RadialGradient getRadialGradient(GameMode mode) {
    return RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: getGradientColors(mode),
      stops: const [0.0, 0.7, 1.0],
    );
  }
  
  /// Get shadow color for the given game mode
  static Color getShadowColor(GameMode mode) {
    switch (mode) {
      case GameMode.noob:
        return ColorConstants.noobCyan.withOpacity(0.3);
      case GameMode.pro:
        return ColorConstants.proRed.withOpacity(0.3);
      case GameMode.beast:
        return ColorConstants.error.withOpacity(0.4);
    }
  }
  
  /// Get box shadow for the given game mode
  static List<BoxShadow> getBoxShadow(GameMode mode, {double elevation = 4.0}) {
    final shadowColor = getShadowColor(mode);
    return [
      BoxShadow(
        color: shadowColor,
        blurRadius: elevation * 2,
        offset: Offset(0, elevation),
        spreadRadius: elevation * 0.5,
      ),
    ];
  }
  
  /// Get cell background color for the given game mode
  static Color getCellBackgroundColor(GameMode mode, {bool isSelected = false, bool hasConflict = false}) {
    if (hasConflict) return ColorConstants.conflictCell.withOpacity(0.3);
    if (isSelected) return getPrimaryColor(mode).withOpacity(0.2);
    return ColorConstants.card;
  }
  
  /// Get cell border color for the given game mode
  static Color getCellBorderColor(GameMode mode, {bool isSelected = false, bool hasConflict = false}) {
    if (hasConflict) return ColorConstants.error;
    if (isSelected) return getPrimaryColor(mode);
    return ColorConstants.gridLine;
  }
  
  /// Get cell text color for the given game mode
  static Color getCellTextColor(GameMode mode, {bool isHighlighted = false, bool isGiven = false}) {
    if (isGiven) return ColorConstants.textWhite;
    if (isHighlighted) return getPrimaryColor(mode);
    return ColorConstants.textGrey;
  }
  
  /// Get button style for the given game mode
  static ButtonStyle getButtonStyle(GameMode mode, {bool isOutlined = false}) {
    final primaryColor = getPrimaryColor(mode);
    
    if (isOutlined) {
      return ButtonStyle(
        foregroundColor: MaterialStateProperty.all(primaryColor),
        side: MaterialStateProperty.all(BorderSide(color: primaryColor)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
    
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(primaryColor),
      foregroundColor: MaterialStateProperty.all(ColorConstants.background),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  /// Get mode-specific icon color
  static Color getIconColor(GameMode mode, {bool isActive = false}) {
    if (isActive) return getPrimaryColor(mode);
    return ColorConstants.textGrey;
  }
  
  /// Get mode-specific divider color
  static Color getDividerColor(GameMode mode) {
    return getPrimaryColor(mode).withOpacity(0.3);
  }
  
  /// Get mode-specific splash color
  static Color getSplashColor(GameMode mode) {
    return getPrimaryColor(mode).withOpacity(0.1);
  }
  
  /// Get mode-specific highlight color
  static Color getHighlightColor(GameMode mode) {
    return getPrimaryColor(mode).withOpacity(0.1);
  }
  
  /// Get mode name as string
  static String getModeName(GameMode mode) {
    switch (mode) {
      case GameMode.noob:
        return 'Noob Mode';
      case GameMode.pro:
        return 'Pro Mode';
      case GameMode.beast:
        return 'Beast Mode';
    }
  }
  
  /// Get mode description
  static String getModeDescription(GameMode mode) {
    switch (mode) {
      case GameMode.noob:
        return '4×4 Grid • Perfect for beginners';
      case GameMode.pro:
        return '9×9 Grid • Classic Sudoku challenge';
      case GameMode.beast:
        return '9×9 Grid • Extreme difficulty';
    }
  }
  
  /// Get mode icon
  static IconData getModeIcon(GameMode mode) {
    switch (mode) {
      case GameMode.noob:
        return Icons.school;
      case GameMode.pro:
        return Icons.sports_esports;
      case GameMode.beast:
        return Icons.whatshot;
    }
  }
}
