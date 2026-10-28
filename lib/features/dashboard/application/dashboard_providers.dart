import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/freshness_utils.dart';
import '../../../domain/models/sensor_data.dart';
import '../../../domain/repositories/dashboard_repository.dart';

/// Synthèse du tableau de bord, entièrement issue des repositories.
final dashboardSnapshotProvider = FutureProvider<DashboardSnapshot>((ref) {
  return ref.watch(dashboardRepositoryProvider).getSnapshot();
});

/// Dernière mesure connue pour chaque zone.
final latestMeasurementsProvider = FutureProvider<Map<String, SensorData>>((
  ref,
) async {
  final zones = await ref.watch(zoneRepositoryProvider).getZones();
  return ref
      .watch(sensorDataRepositoryProvider)
      .getLatestForZones(zones.map((z) => z.id).toList());
});

/// Fraîcheur de la dernière mesure d'une zone.
final zoneFreshnessProvider = Provider.family<ReadingFreshness, String>((
  ref,
  zoneId,
) {
  final measurement = ref
      .watch(latestMeasurementsProvider)
      .valueOrNull?[zoneId];
  return FreshnessUtils.of(measurement);
});
