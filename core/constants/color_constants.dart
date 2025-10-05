import 'package:flutter/material.dart';

/// Color constants for Sudoku Space dark theme
class ColorConstants {
  // Dark Theme Colors
  static const Color background = Color(0xFF0D0D0D);
  static const Color card = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF2A2A2A);
  
  // Game Mode Colors
  static const Color noobCyan = Color(0xFF00E5FF);
  static const Color proRed = Color(0xFFFF1744);
  
  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color textDarkGrey = Color(0xFF757575);
  
  // Interactive Colors
  static const Color primary = noobCyan;
  static const Color secondary = proRed;
  static const Color accent = Color(0xFF00BCD4);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  
  // Grid Colors
  static const Color gridLine = Color(0xFF424242);
  static const Color selectedCell = Color(0xFF1A237E);
  static const Color highlightedCell = Color(0xFF0D47A1);
  static const Color conflictCell = Color(0xFFB71C1C);
  
  // Private constructor to prevent instantiation
  ColorConstants._();
}
