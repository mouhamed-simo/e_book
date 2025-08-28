import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
    // header
  static TextStyle h1 = GoogleFonts.rubik(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -0.5,
  );
  static TextStyle h2 = GoogleFonts.rubik(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  static TextStyle h3 = GoogleFonts.rubik(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  // body
  static TextStyle bodyLarge = GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static TextStyle bodyMeduim = GoogleFonts.rubik(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  static TextStyle bodySmall = GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  //button text
  static TextStyle buttonLarge = GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  static TextStyle buttonMeduim = GoogleFonts.rubik(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static TextStyle buttonSmall = GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // label Text

  static TextStyle labelLarge = GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle labelMeduim = GoogleFonts.rubik(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static TextStyle labelSmall = GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // helper function for color variatations

  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
}
