import '../models/irrigation_settings.dart';

/// Contrat d'accès aux paramètres d'automatisation.
abstract class IrrigationSettingsRepository {
  Future<IrrigationSettings?> getForZone(String zoneId);

  /// Paramètres de toutes les zones, indexés par identifiant de zone.
  Future<Map<String, IrrigationSettings>> getAll();

  Future<void> upsert(IrrigationSettings settings);

  Future<void> delete(String zoneId);
}
