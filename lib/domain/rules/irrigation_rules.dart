/// Règles métier pures de l'irrigation.
///
/// Ces règles décrivent ce que le contrôleur (Raspberry Pi) doit respecter.
/// L'application les utilise pour afficher une alerte cohérente, jamais pour
/// exécuter une vanne.
class IrrigationSafetyCheck {
  final bool canStart;
  final String? reason;

  const IrrigationSafetyCheck._({required this.canStart, this.reason});

  const IrrigationSafetyCheck.allow() : this._(canStart: true);
  const IrrigationSafetyCheck.deny(String reason)
    : this._(canStart: false, reason: reason);

  /// Code technique de la raison du refus (traduit par la présentation).
  String? get code => reason;
}

class IrrigationRules {
  const IrrigationRules();

  /// Fenêtre au-delà de laquelle une mesure est considérée comme périmée.
  static const Duration freshnessWindow = Duration(minutes: 30);

  /// Âge maximum d'une mesure pour autoriser une décision d'arrosage.
  static const Duration maxMeasurementAge = Duration(minutes: 30);

  IrrigationSafetyCheck canStartAutomation({
    required double? currentMoisturePercent,
    required bool isFresh,
    required DateTime? lastMeasurementAt,
    required DateTime now,
    required double startThreshold,
    required double stopThreshold,
    required int minIntervalSeconds,
    required DateTime? lastIrrigationEndAt,
  }) {
    if (!isFresh || currentMoisturePercent == null) {
      return const IrrigationSafetyCheck.deny('data_stale');
    }
    if (startThreshold > stopThreshold) {
      return const IrrigationSafetyCheck.deny('invalid_hysteresis');
    }
    if (lastMeasurementAt != null) {
      final age = now.difference(lastMeasurementAt);
      if (age > maxMeasurementAge) {
        return const IrrigationSafetyCheck.deny('measurement_too_old');
      }
    }
    if (currentMoisturePercent >= startThreshold) {
      return const IrrigationSafetyCheck.deny('moisture_above_start');
    }
    if (lastIrrigationEndAt != null) {
      final since = now.difference(lastIrrigationEndAt);
      if (since.inSeconds < minIntervalSeconds) {
        return const IrrigationSafetyCheck.deny('min_interval_not_elapsed');
      }
    }
    return const IrrigationSafetyCheck.allow();
  }

  bool shouldStop({
    required double? currentMoisturePercent,
    required bool isFresh,
    required int elapsedSeconds,
    required int maxDurationSeconds,
    required double stopThreshold,
  }) {
    if (!isFresh || currentMoisturePercent == null) {
      return true;
    }
    if (elapsedSeconds >= maxDurationSeconds) {
      return true;
    }
    if (currentMoisturePercent >= stopThreshold) {
      return true;
    }
    return false;
  }
}
