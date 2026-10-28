import '../models/zone.dart';

/// Contrat d'accès aux zones de culture.
abstract class ZoneRepository {
  Future<List<Zone>> getZones();

  Future<Zone?> getZone(String zoneId);

  /// Crée une zone. [userId] est l'identifiant du propriétaire (RLS).
  Future<Zone> createZone({
    required String userId,
    required String name,
    String? description,
    bool isActive = true,
  });

  /// Met à jour une zone existante.
  Future<Zone> updateZone(Zone zone);

  /// Supprime une zone (et ses données liées via le schéma).
  Future<void> deleteZone(String zoneId);
}
