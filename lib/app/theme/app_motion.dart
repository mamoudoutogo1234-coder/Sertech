import 'package:flutter/animation.dart';

/// Durées et courbes d'animation du design system Sertech.
///
/// Les animations restent discrètes : elles donnent du feedback sans distraire
/// l'utilisateur qui consulte des données sur le terrain. Une seule courbe
/// d'entrée et une seule courbe de sortie suffisent.
class AppMotion {
  AppMotion._();

  static const Duration fast = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 380);

  /// Décalage entre deux éléments d'une liste qui apparaît.
  static const Duration stagger = Duration(milliseconds: 60);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeOutQuart;
  static const Curve spring = Curves.easeOutBack;
}
