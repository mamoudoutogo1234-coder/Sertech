/// Grille d'espacement et rayons du design system Sertech.
///
/// Les espacements sont tous des multiples de 4 (grille de 8 pour les
/// respirations principales) afin que les écrans restent alignés sans effort.
class AppSpacing {
  AppSpacing._();

  static const double s2 = 2;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s56 = 56;
  static const double s64 = 64;
  static const double s80 = 80;
  static const double s96 = 96;

  /// Marges d'écran et padding de carte de référence.
  static const double screenPadding = s20;
  static const double cardPadding = s20;

  /// Cible tactile minimale (accessibilité et usage avec des gants).
  static const double minTouchTarget = 44;

  /// Largeur de lecture confortable sur tablette.
  static const double maxContentWidth = 640;

  // --- Rayons ---------------------------------------------------------------
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 24;
  static const double radius2xl = 28;
  static const double radiusPill = 999;
}
