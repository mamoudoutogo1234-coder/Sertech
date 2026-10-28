import '../models/sensor_data.dart';
import '../models/zone.dart';
import '../models/irrigation_settings.dart';
import '../models/valve_command.dart';

/// Instantané de synthèse utilisé par le tableau de bord.
///
/// Tout provient des repositories : aucune valeur n'est inventée. Les
/// zones sans mesure apparaissent quand même, avec une absence de donnée
/// explicite.
class DashboardSnapshot {
  final List<Zone> zones;
  final Map<String, SensorData> latestMeasurements;
  final Map<String, IrrigationSettings> settings;
  final List<ValveCommand> recentCommands;
  final DateTime? lastMeasurementAt;

  const DashboardSnapshot({
    required this.zones,
    required this.latestMeasurements,
    required this.settings,
    required this.recentCommands,
    this.lastMeasurementAt,
  });

  SensorData? measurementFor(String zoneId) => latestMeasurements[zoneId];

  IrrigationSettings? settingsFor(String zoneId) => settings[zoneId];

  /// Zone ayant la mesure la plus récente.
  Zone? get freshestZone {
    SensorData? freshest;
    for (final entry in latestMeasurements.entries) {
      final candidate = entry.value;
      if (freshest == null ||
          candidate.recordedAt.isAfter(freshest.recordedAt)) {
        freshest = candidate;
      }
    }
    if (freshest == null) return null;
    for (final zone in zones) {
      if (zone.id == freshest.zoneId) return zone;
    }
    return null;
  }
}

/// Contrat de synthèse pour le tableau de bord.
abstract class DashboardRepository {
  Future<DashboardSnapshot> getSnapshot();
}
