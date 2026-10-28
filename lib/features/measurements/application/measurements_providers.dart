import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/models/sensor_data.dart';
import '../../../domain/repositories/sensor_data_repository.dart';

/// Zone sélectionnée pour l'écran Mesures.
final historyZoneProvider = StateProvider<String?>((ref) => null);

/// Période sélectionnée pour l'écran Mesures.
final historyPeriodProvider = StateProvider<HistoryPeriod>(
  (ref) => HistoryPeriod.day24h,
);

/// Paramètres combinés du graphique d'historique.
typedef HistoryQuery = ({String zoneId, HistoryPeriod period});

/// Historique d'une zone sur une période donnée.
final historyProvider = FutureProvider.family<List<SensorData>, HistoryQuery>((
  ref,
  query,
) {
  return ref
      .watch(sensorDataRepositoryProvider)
      .getHistoryForPeriod(query.zoneId, query.period);
});
