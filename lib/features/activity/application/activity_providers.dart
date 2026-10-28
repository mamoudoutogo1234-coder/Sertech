import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/models/valve_command.dart';
import '../../../domain/models/zone.dart';

/// Détail d'une commande.
final commandByIdProvider = FutureProvider.family<ValveCommand?, String>((
  ref,
  commandId,
) {
  return ref.watch(valveCommandRepositoryProvider).getById(commandId);
});

/// Zone associée à une commande (nom lisible).
final commandZoneProvider = FutureProvider.family<Zone?, String>((ref, zoneId) {
  return ref.watch(zoneRepositoryProvider).getZone(zoneId);
});
