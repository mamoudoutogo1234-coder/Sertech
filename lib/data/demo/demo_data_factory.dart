import 'dart:math' as math;

import '../../domain/models/irrigation_settings.dart';
import '../../domain/models/sensor_data.dart';
import '../../domain/models/valve_command.dart';
import '../../domain/models/zone.dart';
import 'demo_scenario.dart';

/// Générateur de données de démonstration.
///
/// Toutes les valeurs produites ici sont fictives et ne sont écrites que dans
/// les repositories en mémoire. Les dates sont cohérentes avec l'heure de
/// référence afin que les affichages « il y a X min » restent crédibles.
class DemoDataFactory {
  DemoDataFactory({DateTime? reference})
    : reference = reference ?? DateTime.now();

  final DateTime reference;

  static const String demoUserId = 'demo-user-local';

  static const List<String> zoneNames = [
    'Zone Nord — Maraîchage',
    'Zone Sud — Verger',
    'Serre Est — Semis',
  ];

  static const List<String> zoneDescriptions = [
    'Parcelle maraîchère en plein soleil, sol argileux.',
    'Jeunes arbres fruitiers en goutte-à-goutte.',
    'Plateforme de semis sous serre, irrigationfine.',
  ];

  List<Zone> buildZones(DemoScenario scenario) {
    if (scenario == DemoScenario.emptyInstallation) return const [];

    final count = scenario == DemoScenario.noMeasurements ? 2 : 3;
    return List.generate(count, (index) {
      return Zone(
        id: 'demo-zone-${index + 1}',
        userId: demoUserId,
        name: zoneNames[index % zoneNames.length],
        description: zoneDescriptions[index % zoneDescriptions.length],
        isActive: index != 2 || scenario != DemoScenario.staleSensor,
        createdAt: reference.subtract(Duration(days: 30 - index * 5)),
        updatedAt: reference.subtract(Duration(days: index)),
      );
    });
  }

  /// Historique d'humidité par zone, du plus ancien au plus récent.
  Map<String, List<SensorData>> buildMeasurements(
    List<Zone> zones,
    DemoScenario scenario,
  ) {
    final result = <String, List<SensorData>>{};
    if (zones.isEmpty) return result;

    for (var z = 0; z < zones.length; z++) {
      final zone = zones[z];
      if (scenario == DemoScenario.noMeasurements && z == 0) {
        result[zone.id] = const [];
        continue;
      }

      final stale = scenario == DemoScenario.staleSensor && z == 0;
      final hours = 72;
      final step = Duration(hours: 3);
      final random = math.Random(zone.id.hashCode);
      final points = <SensorData>[];

      for (var i = hours ~/ step.inHours; i >= 0; i--) {
        final at = reference.subtract(step * i);
        final wave = math.sin((i / 7) * math.pi) * 6;
        final drift = (hours ~/ step.inHours - i) * 0.12;
        var percent = 52 + wave + drift - z * 4 + (random.nextDouble() * 4 - 2);
        percent = percent.clamp(8.0, 96.0);

        final isOldest = i == 0;
        final recordedAt = stale && isOldest
            ? reference.subtract(const Duration(hours: 52))
            : at;

        points.add(
          SensorData(
            id: 'demo-read-${zone.id}-$i',
            zoneId: zone.id,
            recordedAt: recordedAt,
            moistureRaw: (percent * 3.1).roundToDouble(),
            moisturePercent: double.parse(percent.toStringAsFixed(1)),
            source: 'rpi_fc28',
            metadata: const {'calibrated': true, 'sensor': 'FC-28-DC'},
          ),
        );
      }
      result[zone.id] = points;
    }
    return result;
  }

  Map<String, IrrigationSettings> buildSettings(
    List<Zone> zones,
    DemoScenario scenario,
  ) {
    final result = <String, IrrigationSettings>{};
    for (var i = 0; i < zones.length; i++) {
      final zone = zones[i];
      final invalid = scenario == DemoScenario.failedCommand && i == 0;
      result[zone.id] = IrrigationSettings(
        id: 'demo-settings-${zone.id}',
        zoneId: zone.id,
        autoEnabled: !invalid && i % 2 == 0,
        startThreshold: invalid ? 70 : 40,
        stopThreshold: invalid ? 30 : 65,
        maxDurationSeconds: 600,
        minIntervalSeconds: 1800,
        updatedAt: reference.subtract(Duration(days: i)),
      );
    }
    return result;
  }

  List<ValveCommand> buildCommands(List<Zone> zones, DemoScenario scenario) {
    final result = <ValveCommand>[];
    if (zones.isEmpty) return result;

    void add(
      int index,
      ValveCommandType type,
      ValveCommandStatus status, {
      required Duration ago,
      String? reason,
      String? error,
      String origin = 'mobile_app',
    }) {
      final zone = zones[index % zones.length];
      final requestedAt = reference.subtract(ago);
      result.add(
        ValveCommand(
          id: 'demo-cmd-${result.length + 1}',
          zoneId: zone.id,
          type: type,
          status: status,
          origin: origin,
          reason: reason,
          requestedAt: requestedAt,
          executedAt: status == ValveCommandStatus.executed
              ? requestedAt.add(const Duration(minutes: 6))
              : null,
          errorMessage: error,
        ),
      );
    }

    add(
      0,
      ValveCommandType.open,
      ValveCommandStatus.executed,
      ago: const Duration(hours: 26),
      reason: 'manual',
    );
    add(
      0,
      ValveCommandType.close,
      ValveCommandStatus.executed,
      ago: const Duration(hours: 25, minutes: 50),
      reason: 'manual',
    );
    add(
      1,
      ValveCommandType.open,
      ValveCommandStatus.executed,
      ago: const Duration(hours: 9),
      reason: 'auto_threshold',
      origin: 'rpi_automatic',
    );

    switch (scenario) {
      case DemoScenario.pendingCommands:
        add(
          1,
          ValveCommandType.open,
          ValveCommandStatus.pending,
          ago: const Duration(minutes: 12),
          reason: 'manual',
        );
        add(
          2,
          ValveCommandType.open,
          ValveCommandStatus.pending,
          ago: const Duration(minutes: 4),
          reason: 'manual',
        );
      case DemoScenario.failedCommand:
        add(
          0,
          ValveCommandType.open,
          ValveCommandStatus.failed,
          ago: const Duration(minutes: 35),
          reason: 'manual',
          error: 'Relais inaccessible (câble débranché)',
        );
        add(
          0,
          ValveCommandType.open,
          ValveCommandStatus.executing,
          ago: const Duration(minutes: 3),
          reason: 'manual',
        );
      case DemoScenario.nominal:
        add(
          2,
          ValveCommandType.open,
          ValveCommandStatus.executed,
          ago: const Duration(hours: 2),
          reason: 'auto_threshold',
          origin: 'rpi_automatic',
        );
      case DemoScenario.staleSensor:
      case DemoScenario.noMeasurements:
      case DemoScenario.emptyInstallation:
        break;
    }

    result.sort(
      (a, b) =>
          (b.requestedAt ?? reference).compareTo(a.requestedAt ?? reference),
    );
    return result;
  }
}
