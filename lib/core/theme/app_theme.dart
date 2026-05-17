import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightAccent,
      secondary: AppColors.lightOperator,
      surface: AppColors.lightDisplayBackground,
      onSurface: AppColors.lightTextPrimary,
    ),
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: TextStyle(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 48,
      ),
      displayMedium: TextStyle(
        color: AppColors.lightTextSecondary,
        fontSize: 24,
      ),
      labelLarge: TextStyle(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkAccent,
      secondary: AppColors.darkOperator,
      surface: AppColors.darkDisplayBackground,
      onSurface: AppColors.darkTextPrimary,
    ),
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: TextStyle(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 48,
      ),
      displayMedium: TextStyle(
        color: AppColors.darkTextSecondary,
        fontSize: 24,
      ),
      labelLarge: TextStyle(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    ),
  );
}
