// lib/core/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChitOSTheme {
  static const green      = Color(0xFF128C4F);
  static const greenLight = Color(0xFFE8FAF0);
  static const greenDark  = Color(0xFF075E38);
  static const greenWhatsApp = Color(0xFF25D366);
  static const red        = Color(0xFFE53935);
  static const redLight   = Color(0xFFFFEBEE);
  static const amber      = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFFBEB);
  static const blue       = Color(0xFF1877F2);
  static const blueLight  = Color(0xFFE8F0FE);
  static const textDark   = Color(0xFF1A1A1A);
  static const textGray   = Color(0xFF555555);
  static const bgGray     = Color(0xFFF0F2F5);
  static const white      = Color(0xFFFFFFFF);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: green,
      primary: green,
      surface: bgGray,
    ),
    textTheme: GoogleFonts.notoSansTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: green,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: green, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: green,
      unselectedItemColor: Color(0xFF9E9E9E),
      selectedLabelStyle: GoogleFonts.notoSans(fontSize: 10, fontWeight: FontWeight.w700),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
