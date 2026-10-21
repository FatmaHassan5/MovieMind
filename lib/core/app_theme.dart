import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.background,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ).apply(bodyColor: AppColors.text, displayColor: AppColors.text),
      );
}

abstract class AppText {
  static TextStyle heading(
    double size, {
    Color color = AppColors.text,
    FontWeight weight = FontWeight.w600,
    double letterSpacing = -0.5,
    double? height,
  }) =>
      GoogleFonts.outfit(
        fontSize: size,
        color: color,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle body(
    double size, {
    Color color = AppColors.text,
    FontWeight weight = FontWeight.w500,
    double letterSpacing = 0,
    double? height,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        color: color,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
      );
}
