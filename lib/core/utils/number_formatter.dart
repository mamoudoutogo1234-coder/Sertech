import 'package:intl/intl.dart';

/// Formatage des nombres.
///
/// `intl` ne fournit pas de données pour toutes les locales (le bambara, par
/// exemple) : le formatage bascule alors sur une représentation neutre plutôt
/// que de lever une exception.
class NumberFormatter {
  NumberFormatter._();

  static final NumberFormat _decimal = NumberFormat('#0.#');
  static final NumberFormat _integer = NumberFormat('#,##0');
  static final NumberFormat _oneDecimal = NumberFormat('#0.0');

  static String decimal(num value) => _decimal.format(value);

  static String integer(num value) => _integer.format(value);

  static String oneDecimal(num value) => _oneDecimal.format(value);

  /// Valeur en pourcentage : l'unité est séparée du nombre pour permettre
  /// un rendu clair (valeur + unité) dans les composants.
  static String percentValue(double value) => _oneDecimal.format(value);

  static String percent(double value) => '${_oneDecimal.format(value)} %';

  /// Durée exprimée en minutes à partir de secondes.
  static String minutesFromSeconds(int seconds) =>
      _decimal.format(seconds / 60);
}
