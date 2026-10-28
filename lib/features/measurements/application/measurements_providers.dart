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
final historyProvider = StreamProvider.family<List<SensorData>, HistoryQuery>((
  ref,
  query,
) async* {
  final repo = ref.watch(sensorDataRepositoryProvider);
  // Émettre l'état initial
  final initial = await repo.getHistoryForPeriod(query.zoneId, query.period);
  yield initial;
  // Mettre à jour périodiquement pour refléter les nouvelles mesures
  await for (final _ in Stream.periodic(const Duration(seconds: 2))) {
    try {
      final history = await repo.getHistoryForPeriod(query.zoneId, query.period);
      yield history;
    } catch (_) {
      // Garder les dernières données en cas d'erreur
    }
  }
});
