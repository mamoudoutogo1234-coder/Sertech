import '../models/irrigation_settings.dart';

/// Résultat de validation d'un formulaire de réglages d'irrigation.
///
/// Les erreurs sont exprimées avec des clés techniques : la couche de
/// présentation les traduit. Aucune langue n'est figée dans le domaine.
enum SettingsFieldError {
  startThresholdRequired,
  startThresholdRange,
  stopThresholdRequired,
  stopThresholdRange,
  hysteresisInvalid,
  maxDurationRequired,
  maxDurationRange,
  minIntervalRequired,
  minIntervalNegative,
}

/// Validateur des réglages d'irrigation, testable sans widget.
class SettingsValidation {
  const SettingsValidation._();

  static const double minThreshold = 0;
  static const double maxThreshold = 100;
  static const int minMaxDurationSeconds = 30;
  static const int maxMaxDurationSeconds = 6 * 60 * 60;
  static const int maxMinIntervalSeconds = 24 * 60 * 60;

  /// Valide un formulaire à partir des champs bruts (texte ou null).
  static SettingsValidationResult validateFields({
    String? startThreshold,
    String? stopThreshold,
    String? maxDurationSeconds,
    String? minIntervalSeconds,
  }) {
    final errors = <SettingsFieldError>[];

    final start = _parse(startThreshold);
    final stop = _parse(stopThreshold);
    final duration = _parseInt(maxDurationSeconds);
    final interval = _parseInt(minIntervalSeconds);

    if (start == null) {
      errors.add(SettingsFieldError.startThresholdRequired);
    } else if (start < minThreshold || start > maxThreshold) {
      errors.add(SettingsFieldError.startThresholdRange);
    }

    if (stop == null) {
      errors.add(SettingsFieldError.stopThresholdRequired);
    } else if (stop < minThreshold || stop > maxThreshold) {
      errors.add(SettingsFieldError.stopThresholdRange);
    }

    if (start != null && stop != null && start > stop) {
      errors.add(SettingsFieldError.hysteresisInvalid);
    }

    if (duration == null) {
      errors.add(SettingsFieldError.maxDurationRequired);
    } else if (duration < minMaxDurationSeconds ||
        duration > maxMaxDurationSeconds) {
      errors.add(SettingsFieldError.maxDurationRange);
    }

    if (interval == null) {
      errors.add(SettingsFieldError.minIntervalRequired);
    } else if (interval < 0 || interval > maxMinIntervalSeconds) {
      errors.add(SettingsFieldError.minIntervalNegative);
    }

    return SettingsValidationResult(
      errors.toSet(),
      start,
      stop,
      duration,
      interval,
    );
  }

  /// Valide un objet [IrrigationSettings] déjà typé.
  static SettingsValidationResult validate(IrrigationSettings settings) {
    return validateFields(
      startThreshold: settings.startThreshold.toString(),
      stopThreshold: settings.stopThreshold.toString(),
      maxDurationSeconds: settings.maxDurationSeconds.toString(),
      minIntervalSeconds: settings.minIntervalSeconds.toString(),
    );
  }

  static double? _parse(String? value) {
    if (value == null) return null;
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  static int? _parseInt(String? value) {
    if (value == null) return null;
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    return int.tryParse(normalized);
  }
}

class SettingsValidationResult {
  final Set<SettingsFieldError> errors;
  final double? startThreshold;
  final double? stopThreshold;
  final int? maxDurationSeconds;
  final int? minIntervalSeconds;

  const SettingsValidationResult(
    this.errors,
    this.startThreshold,
    this.stopThreshold,
    this.maxDurationSeconds,
    this.minIntervalSeconds,
  );

  bool get isValid => errors.isEmpty;

  bool has(SettingsFieldError error) => errors.contains(error);
}
