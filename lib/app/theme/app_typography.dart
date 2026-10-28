import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Échelle typographique Sertech.
///
/// Le système tient volontairement en quatre tailles et deux graisses pour
/// rester lisible en plein soleil et garder une hiérarchie nette :
///
/// - `48` : chiffre héro / accroche
/// - `24` : titre d'écran ou de section majeure
/// - `16` : corps de texte, libellés, actions
/// - `12` : métadonnées, badges, légendes
///
/// Manrope est déclarée dans le thème ; les styles ne fixent donc pas la
/// famille pour rester alignés sur le thème clair ou sombre.
class AppTypography {
  AppTypography._();

  static const double heroSize = 48;
  static const double titleSize = 24;
  static const double bodySize = 16;
  static const double captionSize = 12;

  static const List<double> scale = [
    heroSize,
    titleSize,
    bodySize,
    captionSize,
  ];

  static TextTheme lightTextTheme() => _textTheme(
    primary: AppColors.textPrimary,
    secondary: AppColors.textSecondary,
    tertiary: AppColors.textTertiary,
  );

  static TextTheme darkTextTheme() => _textTheme(
    primary: AppColors.darkTextPrimary,
    secondary: AppColors.darkTextSecondary,
    tertiary: AppColors.darkTextTertiary,
  );

  static TextTheme _textTheme({
    required Color primary,
    required Color secondary,
    required Color tertiary,
  }) {
    const hero = TextStyle(
      fontSize: heroSize,
      fontWeight: FontWeight.w600,
      height: 1.02,
      letterSpacing: -1.6,
    );
    const title = TextStyle(
      fontSize: titleSize,
      fontWeight: FontWeight.w600,
      height: 1.16,
      letterSpacing: -0.6,
    );
    const bodyStrong = TextStyle(
      fontSize: bodySize,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: -0.1,
    );
    const body = TextStyle(
      fontSize: bodySize,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
    );
    const captionStrong = TextStyle(
      fontSize: captionSize,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0.15,
    );
    const caption = TextStyle(
      fontSize: captionSize,
      fontWeight: FontWeight.w400,
      height: 1.45,
      letterSpacing: 0.1,
    );

    return TextTheme(
      displayLarge: hero.copyWith(color: primary),
      displayMedium: hero.copyWith(color: primary),
      displaySmall: hero.copyWith(color: primary),
      headlineLarge: title.copyWith(color: primary),
      headlineMedium: title.copyWith(color: primary),
      headlineSmall: title.copyWith(color: primary),
      titleLarge: title.copyWith(color: primary),
      titleMedium: bodyStrong.copyWith(color: primary),
      titleSmall: bodyStrong.copyWith(color: primary),
      bodyLarge: body.copyWith(color: primary),
      bodyMedium: body.copyWith(color: primary),
      bodySmall: caption.copyWith(color: secondary),
      labelLarge: captionStrong.copyWith(color: primary),
      labelMedium: captionStrong.copyWith(color: secondary),
      labelSmall: captionStrong.copyWith(color: tertiary),
    );
  }
}
