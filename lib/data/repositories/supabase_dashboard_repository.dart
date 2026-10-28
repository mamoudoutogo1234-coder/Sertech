import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/irrigation_settings_repository.dart';
import '../../domain/repositories/sensor_data_repository.dart';
import '../../domain/repositories/valve_command_repository.dart';
import '../../domain/repositories/zone_repository.dart';

/// Compose les repositories Supabase pour produire la synthèse du tableau de
/// bord.
class SupabaseDashboardRepository implements DashboardRepository {
  final ZoneRepository zoneRepository;
  final SensorDataRepository sensorDataRepository;
  final IrrigationSettingsRepository irrigationSettingsRepository;
  final ValveCommandRepository valveCommandRepository;

  SupabaseDashboardRepository({
    required this.zoneRepository,
    required this.sensorDataRepository,
    required this.irrigationSettingsRepository,
    required this.valveCommandRepository,
  });

  @override
  Future<DashboardSnapshot> getSnapshot() async {
    final zones = await zoneRepository.getZones();
    final zoneIds = zones.map((z) => z.id).toList();
    final measurements = await sensorDataRepository.getLatestForZones(zoneIds);
    final settings = await irrigationSettingsRepository.getAll();
    final commands = await valveCommandRepository.getRecent(limit: 8);

    DateTime? last;
    for (final measurement in measurements.values) {
      if (last == null || measurement.recordedAt.isAfter(last)) {
        last = measurement.recordedAt;
      }
    }

    return DashboardSnapshot(
      zones: zones,
      latestMeasurements: measurements,
      settings: settings,
      recentCommands: commands,
      lastMeasurementAt: last,
    );
  }
}
