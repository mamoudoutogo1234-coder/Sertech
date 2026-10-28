import '../models/sensor_data.dart';

/// Période d'historique proposée par l'interface.
enum HistoryPeriod {
  day24h,
  days7,
  days30;

  Duration get duration => switch (this) {
    HistoryPeriod.day24h => const Duration(hours: 24),
    HistoryPeriod.days7 => const Duration(days: 7),
    HistoryPeriod.days30 => const Duration(days: 30),
  };

  /// Date de début de la période, arrondie à l'heure pour un rendu stable.
  DateTime startFrom(DateTime now) {
    final raw = now.subtract(duration);
    return switch (this) {
      HistoryPeriod.day24h => DateTime(raw.year, raw.month, raw.day, raw.hour),
      HistoryPeriod.days7 => DateTime(raw.year, raw.month, raw.day),
      HistoryPeriod.days30 => DateTime(raw.year, raw.month, raw.day),
    };
  }
}

/// Contrat d'accès aux mesures d'humidité.
abstract class SensorDataRepository {
  Future<SensorData?> getLatest(String zoneId);

  Future<List<SensorData>> getHistory(String zoneId, {int limit = 50});

  /// Historique sur une période, du plus ancien au plus récent.
  Future<List<SensorData>> getHistoryForPeriod(
    String zoneId,
    HistoryPeriod period, {
    DateTime? now,
  });

  /// Dernière mesure connue pour toutes les zones, indexées par zone.
  Future<Map<String, SensorData>> getLatestForZones(List<String> zoneIds);

  Stream<SensorData?> watchLatest(String zoneId);
}
