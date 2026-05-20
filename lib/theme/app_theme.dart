import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF23AA49); // Fresh green from image
  static const Color background = Color(0xFFF6F7F9); // Light gray background
  static const Color primaryText = Color(0xFF1B1B1B); // Black text
  static const Color secondaryText = Color(0xFF979899); // Light grey text
  static const Color mutedText = Color(0xFF979899); // Alias for secondary text or specific muted color
  static const Color priceText = Color(0xFF1B1B1B);
  static const Color inactiveTab = Color(0xFF2D2D2D); 
  static const Color stroke = Color(0xFFF1F1F5);
  static const Color inputBackground = Color(0xFFF3F5F7);
  static const Color charcoal = Color(0xFF2D2D2D); // Black gray / Charcoal

  static const LinearGradient premiumLinearGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF2C3E50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppDefaults {
  static const double smoothRadius = 18.0;
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];
}

class AppTextStyles {
  static TextStyle get headlineLarge => GoogleFonts.dmSans(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static TextStyle get headlineMedium => GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static TextStyle get titleLarge => GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static TextStyle get titleMedium => GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );
  
  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
  );
}
