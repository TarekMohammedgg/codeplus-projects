import 'package:flutter/material.dart';

/// Centralized color palette for the Doctor Hunt application.
abstract final class AppColors {
  // Brand Colors
  static const Color primary = Color(0xff0EBE7E);
  static const Color primaryDark = Color(0xFF07A86E);
  static const Color primaryLight = Color(0xFFE8FBF6);

  // Secondary Colors
  static const Color secondary = Color(0xFF07D9AD);

  // Background & Surface Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textMain = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF677294);

  // Borders & Disabled
  static const Color outline = Color(0xFFE5E7EB);
  static const Color disabled = Color(0xFFC9D5E8);

  // Status & Feedback Colors
  static const Color success = Color(0xFF0EBE7E);
  static const Color successLight = Color(0xFFE8FBF6);
  static const Color error = Color(0xFFFF4848);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFF3E0);

  // Third-Party Brand Colors
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color facebookBlue = Color(0xFF1877F2);

  // Basic Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color boxShadow = Color(0x140EBE7E);

  // Semantic UI accents
  static const Color attention = Color(0xFFFF003A);
  static const Color favorite = attention;
  static const Color live = attention;
  static const Color rating = Color(0xFFFFB800);
  static const Color textStrong = Color(0xFF222B45);
  static const Color textMuted = Color(0xFF8A94A6);
  static const Color outlineSoft = Color(0xFFE5E9EB);
  static const Color dateOutline = Color(0xFFE8E8E8);
  static const Color surfaceMuted = Color(0xFFF1F4F6);
  static const Color mapPlaceholder = Color(0xFFE2EAF0);

  // Exact shadow tones used by the existing visual language.
  static const Color shadowFaint = Color(0x06000000);
  static const Color shadowSubtle = Color(0x08000000);
  static const Color shadowSoft = Color(0x0A000000);
  static const Color shadowCard = Color(0x0C000000);
  static const Color shadowControl = Color(0x0F000000);
  static const Color shadowNavigation = Color(0x12000000);
  static const Color shadowElevated = Color(0x14000000);
  static const Color shadowImage = Color(0x18000000);
  static const Color shadowSnackbar = Color(0x1A000000);
  static const Color shadowStrong = Color(0x24000000);
  static const Color authBackShadow = Color(0x0C0C3268);
}

/// Application theme, text styles, and visual decorations.
abstract final class AppTheme {
  static const BorderRadius fieldRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(12),
  );

  // Typography
  static const TextStyle display = TextStyle(
    color: AppColors.textMain,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle pageTitle = TextStyle(
    color: AppColors.textMain,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.textMain,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    color: AppColors.textMain,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const TextStyle action = TextStyle(
    color: AppColors.primary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const TextStyle buttonLabel = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// The base Material theme for all Doctor Hunt screens.
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textMain,
      surface: AppColors.surface,
      onSurface: AppColors.textMain,
      outline: AppColors.outline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Rubik',
      textTheme: const TextTheme(
        displaySmall: display,
        headlineMedium: pageTitle,
        titleLarge: sectionTitle,
        bodyLarge: body,
        bodyMedium: body,
        labelLarge: buttonLabel,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        hintStyle: body.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
        labelStyle: label,
        floatingLabelStyle: action,
        border: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: buttonLabel,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textMain,
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          side: const BorderSide(color: AppColors.outline, width: 1.2),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: label,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textMain,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
      ),
    );
  }
}
