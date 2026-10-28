/// Scénarios de démonstration disponibles en mode `INMEMORY`.
///
/// Ces scénarios servent uniquement à explorer l'interface sans matériel.
/// Ils ne sont jamais écrits dans Supabase.
enum DemoScenario {
  /// Installation équipée : zones actives, mesures fraîches, commandes variety.
  nominal,

  /// Zone dont la mesure est périmée (capteur silencieux).
  staleSensor,

  /// Zone sans aucune mesure.
  noMeasurements,

  /// Commandes en attente d'exécution par le contrôleur.
  pendingCommands,

  /// Commande en erreur d'exécution.
  failedCommand,

  /// Installation vide : aucun zone configurée.
  emptyInstallation,
}
