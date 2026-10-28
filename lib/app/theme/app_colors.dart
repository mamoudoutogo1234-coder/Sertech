import 'package:flutter/material.dart';

/// Palette centrale de Sertech, dérivée du logo.
///
/// Une couleur = une intention. Les widgets ne piochent jamais une teinte
/// arbitraire : ils passent par cette classe, par [StatusPalette] ou par les
/// rôles du [ColorScheme] Material 3.
class AppColors {
  AppColors._();

  // --- Marque ---------------------------------------------------------------
  /// Vert des cultures, couleur d'action principale.
  static const Color primary = Color(0xFF0A723B);

  /// Vert profond, réservé aux titres forts et aux fonds héro.
  static const Color primaryDeep = Color(0xFF044B2D);

  /// Vert lumineux du feuillage, utilisé avec parcimonie.
  static const Color leaf = Color(0xFF4EB427);

  /// Teinte claire pour les sélections et les fonds d'indicateur.
  static const Color primaryLight = Color(0xFFE6F3E9);
  static const Color primarySoft = Color(0xFFF1F8F2);

  /// Bleu de l'eau, pour les mesures et l'irrigation.
  static const Color water = Color(0xFF0173AE);
  static const Color waterBright = Color(0xFF0196FE);

  /// Teal du logo, associé aux données de démonstration.
  static const Color teal = Color(0xFF0A868D);

  /// Terre / racines, accent chaud très ponctuel.
  static const Color earth = Color(0xFF8A5A3B);

  // --- Surfaces -------------------------------------------------------------
  static const Color background = Color(0xFFF7FAF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF1F7F1);

  // --- Texte ----------------------------------------------------------------
  static const Color textPrimary = Color(0xFF13251A);
  static const Color textSecondary = Color(0xFF5B6B61);
  static const Color textTertiary = Color(0xFF839187);

  // --- États ----------------------------------------------------------------
  static const Color accentGold = Color(0xFFE6B84A);
  static const Color error = Color(0xFFC43D3D);
  static const Color warning = Color(0xFFA35F00);
  static const Color success = Color(0xFF2E8B57);
  static const Color info = Color(0xFF0173AE);
  static const Color neutral = Color(0xFF5B6B61);
  static const Color demo = Color(0xFF0A868D);

  // --- Bordures -------------------------------------------------------------
  static const Color border = Color(0xFFDDE8DF);
  static const Color divider = Color(0xFFECF2ED);

  // --- Mode sombre ----------------------------------------------------------
  static const Color darkPrimary = Color(0xFF6BD16B);
  static const Color darkPrimaryDeep = Color(0xFF4EB427);
  static const Color darkPrimaryLight = Color(0xFF16291D);
  static const Color darkWater = Color(0xFF5EC6FF);
  static const Color darkWaterBright = Color(0xFF8AD8FF);
  static const Color darkTeal = Color(0xFF4FD8D0);
  static const Color darkEarth = Color(0xFFC99A6A);

  static const Color darkBackground = Color(0xFF07110C);
  static const Color darkSurface = Color(0xFF0E1A13);
  static const Color darkSurfaceAlt = Color(0xFF14241A);
  static const Color darkBorder = Color(0xFF24362B);
  static const Color darkDivider = Color(0xFF1A2A20);

  static const Color darkTextPrimary = Color(0xFFF2F7F3);
  static const Color darkTextSecondary = Color(0xFFA8B8AE);
  static const Color darkTextTertiary = Color(0xFF718278);

  static const Color darkError = Color(0xFFFF8585);
  static const Color darkWarning = Color(0xFFF0C568);
  static const Color darkSuccess = Color(0xFF6BD16B);
  static const Color darkInfo = Color(0xFF5EC6FF);
}

/// Couleurs sémantiques résolues selon la luminosité du thème.
@immutable
class StatusPalette {
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color neutral;
  final Color accent;
  final Color demo;
  final Color border;
  final Color surfaceAlt;
  final Color onAccent;

  const StatusPalette({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.neutral,
    required this.accent,
    required this.demo,
    required this.border,
    required this.surfaceAlt,
    required this.onAccent,
  });

  factory StatusPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const StatusPalette(
        success: AppColors.darkSuccess,
        warning: AppColors.darkWarning,
        error: AppColors.darkError,
        info: AppColors.darkInfo,
        neutral: AppColors.darkTextSecondary,
        accent: AppColors.darkEarth,
        demo: AppColors.darkTeal,
        border: AppColors.darkBorder,
        surfaceAlt: AppColors.darkSurfaceAlt,
        onAccent: AppColors.darkBackground,
      );
    }
    return const StatusPalette(
      success: AppColors.success,
      warning: AppColors.warning,
      error: AppColors.error,
      info: AppColors.info,
      neutral: AppColors.neutral,
      accent: AppColors.earth,
      demo: AppColors.demo,
      border: AppColors.border,
      surfaceAlt: AppColors.surfaceAlt,
      onAccent: Colors.white,
    );
  }
}

extension StatusPaletteContext on BuildContext {
  StatusPalette get statusPalette => StatusPalette.of(this);
}
