import '../../domain/models/sensor_data.dart';
import '../../domain/rules/irrigation_rules.dart';

/// Fraîcheur d'une mesure, du point de vue de l'interface.
enum ReadingFreshness { fresh, expired, unavailable }

/// Utilitaires de fraîcheur.
///
/// Une mesure absente n'est jamais « fraîche » et une mesure périmée n'est
/// jamais présentée comme actuelle.
class FreshnessUtils {
  FreshnessUtils._();

  static ReadingFreshness of(
    SensorData? measurement, {
    DateTime? now,
    Duration window = IrrigationRules.freshnessWindow,
  }) {
    if (measurement == null) return ReadingFreshness.unavailable;
    final reference = now ?? DateTime.now();
    final age = reference.difference(measurement.recordedAt);
    if (age.isNegative) return ReadingFreshness.fresh;
    return age <= window ? ReadingFreshness.fresh : ReadingFreshness.expired;
  }

  static bool isExpired(
    SensorData? measurement, {
    DateTime? now,
    Duration window = IrrigationRules.freshnessWindow,
  }) {
    return of(measurement, now: now, window: window) ==
        ReadingFreshness.expired;
  }
}
