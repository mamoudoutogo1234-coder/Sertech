import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/models/irrigation_settings.dart';
import '../../../domain/models/sensor_data.dart';
import '../../../domain/models/valve_command.dart';
import '../../../domain/models/zone.dart';
import '../../dashboard/application/dashboard_providers.dart';

/// Liste des zones de culture.
final zonesProvider = FutureProvider<List<Zone>>((ref) {
  return ref.watch(zoneRepositoryProvider).getZones();
});

/// Zone par identifiant, sans appel réseau supplémentaire.
final zoneByIdProvider = Provider.family<AsyncValue<Zone?>, String>((
  ref,
  zoneId,
) {
  return ref.watch(zonesProvider).whenData((zones) {
    for (final zone in zones) {
      if (zone.id == zoneId) return zone;
    }
    return null;
  });
});

/// Dernière mesure d'une zone.
final zoneLatestMeasurementProvider =
    FutureProvider.family<SensorData?, String>((ref, zoneId) {
      return ref.watch(sensorDataRepositoryProvider).getLatest(zoneId);
    });

/// Historique récent d'une zone (pour les aperçus).
final zoneHistoryProvider = FutureProvider.family<List<SensorData>, String>((
  ref,
  zoneId,
) {
  return ref.watch(sensorDataRepositoryProvider).getHistory(zoneId, limit: 24);
});

/// Réglages d'irrigation d'une zone.
final zoneSettingsProvider = FutureProvider.family<IrrigationSettings?, String>(
  (ref, zoneId) {
    return ref.watch(irrigationSettingsRepositoryProvider).getForZone(zoneId);
  },
);

/// Commandes récentes d'une zone.
final zoneCommandsProvider = FutureProvider.family<List<ValveCommand>, String>((
  ref,
  zoneId,
) {
  return ref.watch(valveCommandRepositoryProvider).getHistory(zoneId);
});

/// Actions CRUD sur les zones, avec invalidation des vues dépendantes.
final zoneActionsProvider = Provider<ZoneActions>((ref) => ZoneActions(ref));

class ZoneActions {
  ZoneActions(this.ref);

  final Ref ref;

  Future<Zone> create({
    required String name,
    String? description,
    bool isActive = true,
  }) async {
    final repository = ref.read(zoneRepositoryProvider);
    final zones = await repository.getZones();
    final userId = zones.isNotEmpty
        ? zones.first.userId
        : await _currentUserId();
    final zone = await repository.createZone(
      userId: userId,
      name: name.trim(),
      description: _normalize(description),
      isActive: isActive,
    );
    _invalidate();
    return zone;
  }

  Future<Zone> update(Zone zone) async {
    final updated = await ref.read(zoneRepositoryProvider).updateZone(zone);
    _invalidate();
    return updated;
  }

  Future<void> delete(String zoneId) async {
    await ref.read(zoneRepositoryProvider).deleteZone(zoneId);
    _invalidate();
  }

  Future<String> _currentUserId() async {
    final profile = await ref
        .read(profileRepositoryProvider)
        .getCurrentProfile();
    return profile?.id ?? 'local-user';
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  void _invalidate() {
    ref.invalidate(zonesProvider);
    ref.invalidate(dashboardSnapshotProvider);
    ref.invalidate(latestMeasurementsProvider);
  }
}
