import '../../domain/repositories/rpi_health_repository.dart';

/// Implémentation de démonstration : aucun signal de heartbeat n'existe
/// encore dans le schéma, l'état du Raspberry Pi est donc déclaré
/// « inconnu » plutôt qu'« injoignable ».
///
/// Tant que la table / l'endpoint de heartbeat n'existera pas, l'interface
/// affichera un état indéterminé et non un état d'échec.
class InMemoryRpiHealthRepository implements RpiHealthRepository {
  const InMemoryRpiHealthRepository();

  @override
  Future<RpiHealth> getHealth() async =>
      const RpiHealth(reachable: false, status: 'unknown');

  @override
  Stream<RpiHealth> watchHealth() async* {
    yield const RpiHealth(reachable: false, status: 'unknown');
  }
}
