import 'package:flutter/material.dart';

/// Medora's visual system, derived from the supplied screen designs.
///
/// It keeps the interface bright and calm: navy for readable hierarchy,
/// medical blue for actions, and mint/ice blue for supportive surfaces.
abstract final class AppStyles {
  // Brand palette
  static const Color navy = Color(0xFF102E62);
  static const Color primaryBlue = Color(0xFF1D69EE);
  static const Color primaryBlueDark = Color(0xFF1258D8);
  static const Color mint = Color(0xFF4ED8B5);
  static const Color softMint = Color(0xFFE6F8F1);
  static const Color iceBlue = Color(0xFFEAF4FF);
  static const Color canvas = Color(0xFFFEFEFC);
  static const Color nativeSplashBackground = Color(0xFFFEFEFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF62718D);
  static const Color outline = Color(0xFFD6DFEC);
  static const Color disabled = Color(0xFFC9D5E8);
  static const Color success = Color(0xFF2CBF96);

  // Spacing and shape
  static const double pageHorizontalPadding = 24;
  static const double fieldHeight = 64;
  static const double primaryButtonHeight = 58;
  static const double cardRadiusValue = 24;
  static const double fieldRadiusValue = 16;
  static const double buttonRadiusValue = 18;
  static const double circularButtonSize = 64;

  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(cardRadiusValue),
  );
  static const BorderRadius fieldRadius = BorderRadius.all(
    Radius.circular(fieldRadiusValue),
  );
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(buttonRadiusValue),
  );
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(999));

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x180C3268), blurRadius: 24, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> blueButtonShadow = [
    BoxShadow(color: Color(0x331D69EE), blurRadius: 18, offset: Offset(0, 8)),
  ];

  // Typography
  static const TextStyle display = TextStyle(
    color: navy,
    fontSize: 42,
    fontWeight: FontWeight.w800,
    height: 1.13,
  );

  static const TextStyle pageTitle = TextStyle(
    color: navy,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: navy,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle body = TextStyle(
    color: textSecondary,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    color: navy,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle action = TextStyle(
    color: primaryBlue,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle buttonLabel = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// The base Material theme for all Medora screens.
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: Colors.white,
      secondary: mint,
      onSecondary: navy,
      surface: surface,
      onSurface: navy,
      outline: outline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: canvas,
      fontFamily: 'Roboto',
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
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: body.copyWith(color: textSecondary),
        labelStyle: label,
        floatingLabelStyle: action,
        border: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: primaryBlue, width: 1.75),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: Color(0xFFD94B4B)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(primaryButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: buttonLabel,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: navy,
          minimumSize: const Size.fromHeight(primaryButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          side: const BorderSide(color: primaryBlue, width: 1.3),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: label,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      dividerTheme: const DividerThemeData(color: outline, thickness: 1),
    );
  }

  /// Use for white selection, provider, and appointment cards.
  static BoxDecoration cardDecoration({bool selected = false}) => BoxDecoration(
    color: surface,
    borderRadius: cardRadius,
    border: Border.all(
      color: selected ? primaryBlue : outline,
      width: selected ? 1.8 : 1,
    ),
    boxShadow: softShadow,
  );

  /// Use for the round onboarding previous/next buttons.
  static BoxDecoration circularActionDecoration({bool primary = true}) =>
      BoxDecoration(
        color: primary ? primaryBlue : surface,
        shape: BoxShape.circle,
        border: primary ? null : Border.all(color: outline),
        boxShadow: primary ? blueButtonShadow : softShadow,
      );

  /// Smooth-page-indicator dimensions from the onboarding layouts.
  static BoxDecoration onboardingDot({bool active = false}) => BoxDecoration(
    color: active ? primaryBlue : disabled,
    borderRadius: pillRadius,
  );
}
