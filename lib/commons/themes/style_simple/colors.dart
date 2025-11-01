// lib/commons/themes/style_simple/colors.dart
import 'package:flutter/material.dart';

/// NavigUI Color Palette - Exact colors from design
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ============================================
  // EXACT COLORS FROM DESIGN
  // ============================================

  // Basic Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Main Background
  static const Color background = Color(0xFF1A1A1A);

  // Greys
  static const Color grey1 = Color(0xFF1A1A1A);
  static const Color grey2 = Color(0xFF6C6C6C);
  static const Color grey3 = Color(0xFFD9D9D9);
  static const Color grey4 = Color(0xFF2C2C2C);
  static const Color grey5 = Color(0xFF393939);
  static const Color grey6 = Color(0xFFBFBFBF);
  static const Color grey7 = Color(0xFFB8B8B8);
  static const Color grey8 = Color(0xFFBDBDBD);
  static const Color grey9 = Color(0xFFCECECE);

  // Electric Lime (Primary)
  static const Color electricLime = Color(0xFFD2FF1F);
  static const Color electricLime2 = Color(0xFFABD600);
  static const Color electricLime3 = Color(0xFFDFFC6B);

  // Yellow/Gold
  static const Color yellow1 = Color(0xFFF7CE45);
  static const Color yellow2 = Color(0xFFFFE078);
  static const Color yellow3 = Color(0xFFFEF19D);
  static const Color yellow4 = Color(0xFFFFFF88);
  static const Color yellow5 = Color(0xFFFBBC09);

  // Blue
  static const Color blue1 = Color(0xFF01031A);
  static const Color blue2 = Color(0xFF172343);

  // Dark Blue/Black
  static const Color darkBlue = Color(0xFF0E101F);

  // Purple/Pink
  static const Color purple1 = Color(0xFFAB93E0);
  static const Color purple2 = Color(0xFFDCC1FF);
  static const Color purple3 = Color(0xFFE168FF);
  static const Color purple4 = Color(0xFFF6D3FF);
  static const Color purple5 = Color(0xFF885AEF);
  static const Color purple6 = Color(0xFF9288EE);
  static const Color purple7 = Color(0xFFCEBCFF);
  static const Color purple8 = Color(0xFF9D76F3);

  // Orange/Red
  static const Color orange1 = Color(0xFFFF825C);
  static const Color orange2 = Color(0xFFE0A961);
  static const Color orange3 = Color(0xFFF1511B);
  static const Color orange4 = Color(0xFFEC704B);
  static const Color orange5 = Color(0xFFFF4710);
  static const Color red1 = Color(0xFFC63F47);

  // Cyan/Teal
  static const Color cyan1 = Color(0xFFD0FCFF);

  // Green
  static const Color green1 = Color(0xFF80CC28);

  // Light/Text Colors
  static const Color lightText = Color(0xFFEFEFEF);

  // ============================================
  // SEMANTIC COLORS (For easier usage)
  // ============================================

  // Primary
  static const Color primary = electricLime;
  static const Color primaryDark = electricLime2;
  static const Color primaryLight = electricLime3;

  // Backwards-compatible aliases (used across the codebase)
  static const Color secondary =
      Color(0xFFE168FF); // Pink/purple accent (alias)
  static const Color accent = green1; // Accent green (alias)

  // Common grey aliases expected by existing code
  static const Color grey600 = grey6;
  static const Color grey700 = grey5;
  static const Color grey400 = grey7;

  // Surface/Background
  static const Color surface = grey4;
  static const Color surfaceLight = grey5;
  static const Color surfaceVariant = grey1;

  // Text
  static const Color textPrimary = white;
  static const Color textSecondary = grey7;
  static const Color textTertiary = grey6;
  static const Color textDisabled = grey2;
  static const Color textOnPrimary = black;

  // Status
  static const Color success = green1;
  static const Color warning = yellow5;
  static const Color error = red1;
  static const Color info = blue2;

  // Borders
  static const Color stroke = darkBlue;
  static const Color border = grey4;
  static const Color divider = grey2;
}
