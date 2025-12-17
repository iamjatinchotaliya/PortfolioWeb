import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Cyberpunk/Aurora Color Scheme - Light Theme
  static const Color lightPrimary = Color(0xFF00D9FF); // Electric Cyan
  static const Color lightSecondary = Color(0xFFFF006E); // Hot Pink
  static const Color lightAccent = Color(0xFFFFBE0B); // Golden Yellow
  static const Color lightBackground = Color(0xFFF8F9FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFFF3864);
  static const Color lightSuccess = Color(0xFF00F5A0);
  static const Color lightWarning = Color(0xFFFFBE0B);
  static const Color lightInfo = Color(0xFF00D9FF);

  // Premium Dark Theme - Deep Space with Neon Accents
  static const Color darkPrimary = Color(0xFF00F5FF); // Neon Cyan
  static const Color darkSecondary = Color(0xFFFF0080); // Neon Pink
  static const Color darkAccent = Color(0xFFFFD60A); // Neon Yellow
  static const Color darkBackground = Color(0xFF0A0E27); // Deep Space Blue
  static const Color darkSurface = Color(0xFF1A1F3A); // Dark Slate
  static const Color darkError = Color(0xFFFF4757);
  static const Color darkSuccess = Color(0xFF00F2A0);
  static const Color darkWarning = Color(0xFFFFD60A);
  static const Color darkInfo = Color(0xFF00F5FF);

  // Text Colors Light
  static const Color lightTextPrimary = Color(0xFF0A0E27);
  static const Color lightTextSecondary = Color(0xFF4A5568);
  static const Color lightTextTertiary = Color(0xFF718096);

  // Text Colors Dark
  static const Color darkTextPrimary = Color(0xFFF7FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E0);
  static const Color darkTextTertiary = Color(0xFFA0AEC0);

  // Premium Gradient Collections
  static const List<Color> primaryGradient = [Color(0xFF00D9FF), Color(0xFF0099FF)];

  static const List<Color> secondaryGradient = [Color(0xFFFF006E), Color(0xFFFF0080)];

  static const List<Color> accentGradient = [Color(0xFFFFBE0B), Color(0xFFFF6B00)];

  // New: Aurora Gradient
  static const List<Color> auroraGradient = [Color(0xFF00F5FF), Color(0xFF00D9FF), Color(0xFF0099FF), Color(0xFF9D4EDD)];

  // New: Sunset Gradient
  static const List<Color> sunsetGradient = [Color(0xFFFF006E), Color(0xFFFF4D6D), Color(0xFFFFBE0B), Color(0xFFFF6B00)];

  // New: Cosmic Gradient
  static const List<Color> cosmicGradient = [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF2E3654), Color(0xFF3D4E81)];

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;
  static const double spacing96 = 96.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Animations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationSlower = Duration(milliseconds: 800);

  // Shadows
  static List<BoxShadow> get lightShadow => [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))];

  static List<BoxShadow> get lightShadowLarge => [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))];

  static List<BoxShadow> get darkShadow => [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))];

  static List<BoxShadow> get darkShadowLarge => [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))];

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        tertiary: lightAccent,
        error: lightError,
        surface: lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onError: Colors.white,
      ),
      textTheme: _buildTextTheme(lightTextPrimary, lightTextSecondary),
      elevatedButtonTheme: _buildElevatedButtonTheme(true),
      outlinedButtonTheme: _buildOutlinedButtonTheme(true),
      textButtonTheme: _buildTextButtonTheme(true),
      cardTheme: _buildCardTheme(true),
      appBarTheme: _buildAppBarTheme(true),
      inputDecorationTheme: _buildInputDecorationTheme(true),
      dividerTheme: DividerThemeData(color: lightTextTertiary.withOpacity(0.2), thickness: 1),
      iconTheme: const IconThemeData(color: lightTextSecondary),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        tertiary: darkAccent,
        error: darkError,
        surface: darkSurface,
        onPrimary: darkBackground,
        onSecondary: darkBackground,
        onSurface: darkTextPrimary,
        onError: darkBackground,
      ),
      textTheme: _buildTextTheme(darkTextPrimary, darkTextSecondary),
      elevatedButtonTheme: _buildElevatedButtonTheme(false),
      outlinedButtonTheme: _buildOutlinedButtonTheme(false),
      textButtonTheme: _buildTextButtonTheme(false),
      cardTheme: _buildCardTheme(false),
      appBarTheme: _buildAppBarTheme(false),
      inputDecorationTheme: _buildInputDecorationTheme(false),
      dividerTheme: DividerThemeData(color: darkTextTertiary.withOpacity(0.2), thickness: 1),
      iconTheme: const IconThemeData(color: darkTextSecondary),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.bold, color: primary, height: 1.1),
      displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.bold, color: primary, height: 1.2),
      displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: primary, height: 1.2),
      headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700, color: primary, height: 1.3),
      headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600, color: primary, height: 1.3),
      headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: primary, height: 1.3),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: primary, height: 1.4),
      titleMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: primary, height: 1.4),
      titleSmall: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: primary, height: 1.4),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: secondary, height: 1.6),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: secondary, height: 1.6),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, color: secondary, height: 1.5),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: primary),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: secondary),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(bool isLight) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: isLight ? lightPrimary : darkPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(bool isLight) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: isLight ? lightPrimary : darkPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        side: BorderSide(color: isLight ? lightPrimary : darkPrimary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(bool isLight) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: isLight ? lightPrimary : darkPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  static CardThemeData _buildCardTheme(bool isLight) {
    return CardThemeData(
      color: isLight ? lightSurface : darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLarge)),
      margin: const EdgeInsets.all(0),
    );
  }

  static AppBarTheme _buildAppBarTheme(bool isLight) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: isLight ? lightTextPrimary : darkTextPrimary),
      titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: isLight ? lightTextPrimary : darkTextPrimary),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(bool isLight) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isLight ? lightSurface : darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: isLight ? lightTextTertiary.withOpacity(0.3) : darkTextTertiary.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: isLight ? lightTextTertiary.withOpacity(0.3) : darkTextTertiary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: isLight ? lightPrimary : darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: isLight ? lightError : darkError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: isLight ? lightError : darkError, width: 2),
      ),
      labelStyle: GoogleFonts.inter(color: isLight ? lightTextSecondary : darkTextSecondary),
      hintStyle: GoogleFonts.inter(color: isLight ? lightTextTertiary : darkTextTertiary),
    );
  }
}
