import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- BASE COLORS ---
  static const Color primary = Color(0xFFE65100);
  static const Color primaryHover = Color(0xFFBF360C);
  static const Color primaryActive = Color(0xFFBF360C);
  static const Color primarySubtle = Color(0xFFFBE9E7);

  // --- NEUTRAL & SURFACE ---
  static const Color pageBackground = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color borderDefault = Color(0xFFE0E0E0);
  static const Color borderFocus = Color(0xFFE65100);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // --- SEMANTIC COLORS (GATE STATUS) ---
  static const Color success = Color(0xFF2E7D32);        // OPEN
  static const Color successSubtle = Color(0xFFE8F5E9);
  static const Color successBorder = Color(0xFFA5D6A7);

  static const Color warning = Color(0xFFE65100);        // ALERT
  static const Color warningSubtle = Color(0xFFFFF3E0);
  static const Color warningBorder = Color(0xFFFFCC80);

  static const Color danger = Color(0xFFC62828);         // CLOSED
  static const Color dangerSubtle = Color(0xFFFFEBEE);
  static const Color dangerBorder = Color(0xFFEF9A9A);

  static const Color info = Color(0xFF1565C0);
  static const Color infoSubtle = Color(0xFFE3F2FD);

  // --- OFFLINE/STALE STATE ---
  static const Color offlineBannerBg = Color(0xFF37474F);
  static const Color offlineBannerText = Color(0xFFFFFFFF);
  static const Color staleTimestamp = Color(0xFFF57C00);

  // --- SPACING ---
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // --- RADIUS ---
  static const double radiusSmall = 8.0;
  static const double radiusDefault = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusFull = 9999.0;
  
  static final BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static final BorderRadius borderRadiusDefault = BorderRadius.circular(radiusDefault);
  static final BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  // Using 9999 represents fully rounded (pill shape) in UI context.
  static final BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // --- TYPOGRAPHY (Noto Sans) ---
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.notoSans(fontSize: 48, fontWeight: FontWeight.w700, color: textPrimary),
    headlineLarge: GoogleFonts.notoSans(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary),
    titleLarge: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
    titleMedium: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
    bodyLarge: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary),
    bodyMedium: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary),
    bodySmall: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w400, color: textPrimary),
    labelSmall: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary),
  );

  static final TextStyle pinInputStyle = GoogleFonts.notoSansMono(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  // --- THEMEDATA GENERATOR ---
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        surface: cardBackground,
        error: danger,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: pageBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: cardBackground,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: textSecondary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLarge)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusSmall),
      ),
    );
  }
}
