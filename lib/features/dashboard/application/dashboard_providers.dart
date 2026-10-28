import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/freshness_utils.dart';
import '../../../domain/models/sensor_data.dart';
import '../../../domain/repositories/dashboard_repository.dart';

/// Synthèse du tableau de bord, entièrement issue des repositories.
final dashboardSnapshotProvider = StreamProvider<DashboardSnapshot>((ref) async* {
  final repo = ref.watch(dashboardRepositoryProvider);

  yield* Stream.periodic(const Duration(milliseconds: 500)).asyncMap((_) async {
    try {
      final measurements = await ref.read(latestMeasurementsProvider.future);
      final snapshot = await repo.getSnapshot();
      return DashboardSnapshot(
        zones: snapshot.zones,
        latestMeasurements: measurements.isNotEmpty
            ? measurements
            : snapshot.latestMeasurements,
        settings: snapshot.settings,
        recentCommands: snapshot.recentCommands,
        lastMeasurementAt: snapshot.lastMeasurementAt,
      );
    } catch (e) {
      rethrow;
    }
  });
});

/// Dernière mesure connue pour chaque zone en temps réel.
final latestMeasurementsProvider = StreamProvider<Map<String, SensorData>>((
  ref,
) async* {
  final zones = await ref.watch(zoneRepositoryProvider).getZones();
  if (zones.isEmpty) {
    yield const {};
    return;
  }
  final repo = ref.watch(sensorDataRepositoryProvider);
  final current = <String, SensorData>{};
  for (final zone in zones) {
    try {
      final latest = await repo.getLatest(zone.id);
      if (latest != null) current[zone.id] = latest;
    } catch (_) {}
  }
  yield Map<String, SensorData>.from(current);
  final streams = <Stream<SensorData?>>[];
  for (final zone in zones) {
    try {
      streams.add(repo.watchLatest(zone.id));
    } catch (e) {
      // Ignorer les erreurs de souscription
    }
  }
  if (streams.isEmpty) {
    yield Map<String, SensorData>.from(current);
    return;
  }
  await for (final _ in StreamGroup.merge(streams)) {
    for (final zone in zones) {
      try {
        final latest = await repo.getLatest(zone.id);
        if (latest != null) {
          current[zone.id] = latest;
        } else {
          current.remove(zone.id);
        }
      } catch (_) {}
    }
    yield Map<String, SensorData>.from(current);
  }
});

/// Fraîcheur de la dernière mesure d'une zone.
final zoneFreshnessProvider = Provider.family<ReadingFreshness, String>((
  ref,
  zoneId,
) {
  final measurement = ref.watch(latestMeasurementsProvider).valueOrNull?[zoneId];
  return FreshnessUtils.of(measurement);
});
