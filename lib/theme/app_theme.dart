import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFFE65100); // Deep Orange Accent
  static const Color background = Color(0xFFFFFDF7); // Very Light Cream Background
  static const Color primaryText = Color(0xFF0D1C2E); // Deep Navy/Charcoal
  static const Color secondaryText = Color(0xFF8D8D8D); // Light Grey/Brown
  static const Color mutedText = Color(0xFFB0B0B0); 
  static const Color priceText = Color(0xFF0D1C2E);
  static const Color inactiveTab = Color(0xFF8D8D8D); 
  static const Color stroke = Color(0xFFEAE5D9); // Slightly warmer stroke
  static const Color inputBackground = Color(0xFFFFF3E0); // Pale Orange
  static const Color charcoal = Color(0xFF0D1C2E); 
  static const Color secondaryAccent = Color(0xFFFFE082); // Soft yellow accent

  static const LinearGradient premiumLinearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFEDB3),
      Color(0xFFFFD54F),
    ],
  );
}

class AppDefaults {
  static const double smoothRadius = 28.0; // Redesigned rounded card style
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      blurRadius: 12,
      spreadRadius: 1,
      offset: Offset(0, 6),
      color: Colors.black12,
    ),
  ];
}

class AppTextStyles {
  // Screen Titles: 40pt, w700
  static TextStyle get headlineLarge => GoogleFonts.dmSans(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    letterSpacing: -0.5,
  );

  // Section Headings: 30pt, w600
  static TextStyle get headlineMedium => GoogleFonts.dmSans(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static TextStyle get titleLarge => GoogleFonts.dmSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  // Product Names: 24pt, w600
  static TextStyle get titleMedium => GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );
  
  // Small Info: 16pt, w400
  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );
}

