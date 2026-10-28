import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/freshness_utils.dart';
import '../../../domain/models/valve_command.dart';
import '../../../domain/models/zone.dart';
import '../../irrigation/application/irrigation_providers.dart';

/// Type d'événement système dérivé de données réelles.
enum SystemEventType {
  staleMeasurement,
  pendingCommand,
  failedCommand,
  noMeasurement,
}

/// Événement calculé — aucune notification n'est stockée en base et aucun
/// événement n'est inventé : tout provient des mesures et des commandes.
class SystemEvent {
  final String id;
  final SystemEventType type;
  final String zoneId;
  final String zoneName;
  final DateTime? at;
  final String? commandId;

  const SystemEvent({
    required this.id,
    required this.type,
    required this.zoneId,
    required this.zoneName,
    this.at,
    this.commandId,
  });
}

final systemEventsProvider = FutureProvider<List<SystemEvent>>((ref) async {
  final zones = await ref.watch(zoneRepositoryProvider).getZones();
  if (zones.isEmpty) return const [];

  final measurements = await ref
      .watch(sensorDataRepositoryProvider)
      .getLatestForZones(zones.map((z) => z.id).toList());
  final commands = await ref.watch(recentCommandsProvider.future);

  final events = <SystemEvent>[];

  for (final zone in zones) {
    final measurement = measurements[zone.id];
    final freshness = FreshnessUtils.of(measurement);
    if (measurement == null) {
      events.add(
        SystemEvent(
          id: 'no-measurement-${zone.id}',
          type: SystemEventType.noMeasurement,
          zoneId: zone.id,
          zoneName: zone.name,
        ),
      );
    } else if (freshness == ReadingFreshness.expired) {
      events.add(
        SystemEvent(
          id: 'stale-${zone.id}',
          type: SystemEventType.staleMeasurement,
          zoneId: zone.id,
          zoneName: zone.name,
          at: measurement.recordedAt,
        ),
      );
    }
  }

  for (final command in commands) {
    if (command.status == ValveCommandStatus.failed) {
      events.add(
        SystemEvent(
          id: 'failed-${command.id}',
          type: SystemEventType.failedCommand,
          zoneId: command.zoneId,
          zoneName: _zoneName(zones, command.zoneId),
          at: command.requestedAt,
          commandId: command.id,
        ),
      );
    } else if (command.status == ValveCommandStatus.pending &&
        command.requestedAt != null &&
        DateTime.now().difference(command.requestedAt!) >
            const Duration(minutes: 10)) {
      events.add(
        SystemEvent(
          id: 'pending-${command.id}',
          type: SystemEventType.pendingCommand,
          zoneId: command.zoneId,
          zoneName: _zoneName(zones, command.zoneId),
          at: command.requestedAt,
          commandId: command.id,
        ),
      );
    }
  }

  events.sort((a, b) {
    final left = a.at ?? DateTime.fromMillisecondsSinceEpoch(0);
    final right = b.at ?? DateTime.fromMillisecondsSinceEpoch(0);
    return right.compareTo(left);
  });
  return events;
});

String _zoneName(List<Zone> zones, String zoneId) {
  for (final zone in zones) {
    if (zone.id == zoneId) return zone.name;
  }
  return zoneId;
}

final systemEventCountProvider = Provider<int>((ref) {
  return ref.watch(systemEventsProvider).valueOrNull?.length ?? 0;
});

final hasStaleDataProvider = Provider<bool>((ref) {
  final measurements = ref
      .watch(activityLatestMeasurementsProvider)
      .valueOrNull;
  if (measurements == null) return false;
  for (final measurement in measurements.values) {
    if (FreshnessUtils.isExpired(measurement)) return true;
  }
  return false;
});

final activityLatestMeasurementsProvider = FutureProvider<Map<String, dynamic>>(
  (ref) async {
    final zones = await ref.watch(zoneRepositoryProvider).getZones();
    return ref
        .watch(sensorDataRepositoryProvider)
        .getLatestForZones(zones.map((z) => z.id).toList());
  },
);
