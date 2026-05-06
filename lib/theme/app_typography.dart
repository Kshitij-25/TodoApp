import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle get display => GoogleFonts.fraunces(
        fontSize: 40,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get heading1 => GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get heading2 => GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get body => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get caption => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get label => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get mono => GoogleFonts.dmMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );
}
