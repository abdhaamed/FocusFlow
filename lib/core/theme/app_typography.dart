// ASSIGNED TO: Hamid
// TODO(Hamid): Define specific text styles (h1, body, etc.) as needed.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700);
  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600);
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400);
  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400);
  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500);
  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500);
}
