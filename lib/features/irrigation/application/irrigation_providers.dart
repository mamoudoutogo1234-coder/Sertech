import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/models/irrigation_settings.dart';
import '../../../domain/models/valve_command.dart';
import '../../dashboard/application/dashboard_providers.dart';
import '../../zones/application/zones_providers.dart';

/// Tous les réglages d'irrigation, indexés par zone.
final irrigationSettingsProvider =
    FutureProvider<Map<String, IrrigationSettings>>((ref) {
      return ref.watch(irrigationSettingsRepositoryProvider).getAll();
    });

/// Zone sélectionnée sur l'écran Irrigation (partagée avec la fiche zone).
final irrigationZoneProvider = StateProvider<String?>((ref) => null);

/// Historique récent toutes zones confondues.
final recentCommandsProvider = FutureProvider<List<ValveCommand>>((ref) {
  return ref.watch(valveCommandRepositoryProvider).getRecent(limit: 50);
});

/// Actions d'irrigation : enregistrement des réglages et demandes de commande.
final irrigationActionsProvider = Provider<IrrigationActions>(
  (ref) => IrrigationActions(ref),
);

class IrrigationActions {
  IrrigationActions(this.ref);

  final Ref ref;

  Future<IrrigationSettings> saveSettings(IrrigationSettings settings) async {
    final repository = ref.read(irrigationSettingsRepositoryProvider);
    await repository.upsert(settings);
    try {
      final saved = await repository.getForZone(settings.zoneId);
      _invalidateAll();
      return saved ?? settings;
    } catch (_) {
      _invalidateAll();
      return settings;
    }
  }

  /// Enregistre une demande d'ouverture. Le statut reste `pending` : seule
  /// l'insertion réussit ici, l'exécution appartient au contrôleur.
  Future<ValveCommand> requestOpen(String zoneId, {String? reason}) async {
    final command = await ref
        .read(valveCommandRepositoryProvider)
        .requestOpen(zoneId, origin: 'mobile_app', reason: reason);
    _invalidateAll();
    return command;
  }

  Future<ValveCommand> requestClose(String zoneId, {String? reason}) async {
    final command = await ref
        .read(valveCommandRepositoryProvider)
        .requestClose(zoneId, origin: 'mobile_app', reason: reason);
    _invalidateAll();
    return command;
  }

  void _invalidateAll() {
    ref.invalidate(recentCommandsProvider);
    ref.invalidate(irrigationSettingsProvider);
    ref.invalidate(dashboardSnapshotProvider);
    ref.invalidate(zoneSettingsProvider);
    ref.invalidate(zoneCommandsProvider);
  }
}

/// Paramètres par défaut proposés à la création d'une zone.
IrrigationSettings defaultSettingsFor(String zoneId) {
  return IrrigationSettings(
    id: 'settings-$zoneId',
    zoneId: zoneId,
    autoEnabled: false,
    startThreshold: 40,
    stopThreshold: 65,
    maxDurationSeconds: 600,
    minIntervalSeconds: 1800,
  );
}
