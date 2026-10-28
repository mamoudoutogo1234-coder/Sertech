import '../models/valve_command.dart';

/// Contrat d'accès aux commandes de vanne.
///
/// L'application ne fait que *demander* une commande : elle l'insère en
/// statut `pending`. Le Raspberry Pi est seul habilité à la faire évoluer
/// vers `executing`, `executed` ou `failed`.
abstract class ValveCommandRepository {
  Future<ValveCommand> requestOpen(
    String zoneId, {
    String? origin,
    String? reason,
  });

  Future<ValveCommand> requestClose(
    String zoneId, {
    String? origin,
    String? reason,
  });

  Future<List<ValveCommand>> getHistory(String zoneId, {int limit = 20});

  /// Historique toutes zones confondues, du plus récent au plus ancien.
  Future<List<ValveCommand>> getRecent({int limit = 50});

  Future<ValveCommand?> getById(String commandId);

  Stream<List<ValveCommand>> watchForZone(String zoneId);
}
