# Sertech

Sertech est une application Flutter de supervision et pilotage de l'irrigation agricole. Elle permet de visualiser l'état des zones, les mesures des capteurs, l'activité des vannes, et de configurer les paramètres d'irrigation automatisée.

## Fonctionnalités principales

- **Tableau de bord** : aperçu synthétique des zones, mesures récentes et commandes avec mise à jour en temps réel
- **Zones** : gestion des parcelles/zones avec seuils d'irrigation
- **Mesures** : historique des relevés d'humidité par zone avec actualisation automatique
- **Irrigation** : pilotage manuel des vannes et configuration des paramètres
- **Activité** : historique des commandes de vanne
- **Paramètres** : thème, langue, source de données (Supabase / données de démonstration)
- **Mode démo** : fonctionne hors ligne avec des données de démonstration cohérentes
- **Temps réel (Supabase)** : le dashboard se met à jour automatiquement à l'insertion de nouvelles mesures dans `sensor_data` sans actualisation manuelle.

## Architecture

L'application suit une architecture en couches (Clean Architecture) :
- `lib/domain/` : modèles, règles métier pures, contrats de repositories
- `lib/data/` : implémentations (Supabase, in-memory/demo), configuration
- `lib/features/` : couches présentation/application par fonctionnalité (Riverpod)
- `lib/app/` : routage, thème, providers globaux
- `lib/core/` : utilitaires, widgets partagés, configuration

Voir [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) pour plus de détails.

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ^3.13.3
- [Dart SDK](https://dart.dev/get-dart) (inclus avec Flutter)
- [Supabase CLI](https://supabase.com/docs/guides/cli) (pour le développement local)
- Un émulateur Android/iOS ou un appareil physique

## Configuration de l'environnement

### Variables d'environnement

L'application utilise `String.fromEnvironment`. Pour un développement local avec Supabase local :

```bash
# .env (facultatif, des valeurs par défaut existent pour le dev local)
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_PUBLISHABLE_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

Les valeurs par défaut dans `lib/core/config/app_config.dart` pointent vers un Supabase local (`http://127.0.0.1:54321`). Vous pouvez aussi les passer via `--dart-define`.

**Sur un appareil physique connecté au même réseau**, remplacez `127.0.0.1` par l'adresse IP LAN de votre Raspberry Pi (ex. `http://192.168.1.100:54321`), car `127.0.0.1` désigne l'appareil lui-même.

### Supabase local

1. Installer [Supabase CLI](https://supabase.com/docs/guides/cli)
2. Démarrer Supabase local depuis le dossier du projet :
```bash
supabase start
```
3. Appliquer les migrations (déjà dans `supabase/migrations/`) :
```bash
supabase db reset  # ou supabase migration up
```

Le schéma est défini dans `supabase/migrations/20251015000000_init_sertech.sql`. Les migrations incluent l'activation de Realtime pour `sensor_data` et `REPLICA IDENTITY FULL`. Voir [docs/SUPABASE_SETUP.md](docs/SUPABASE_SETUP.md) pour plus de détails.

## Installation et exécution

```bash
# Installer les dépendances
flutter pub get

# Générer les fichiers de localisation (si nécessaire)
flutter gen-l10n

# Lancer l'application en mode debug
flutter run

# Lancer sur un appareil spécifique
flutter run -d <device_id>

# Avec des variables d'environnement personnalisées
flutter run --dart-define=SUPABASE_URL=http://192.168.1.100:54321 --dart-define=SUPABASE_PUBLISHABLE_KEY=<votre_cle>
```

## Mode de données

L'application prend en charge deux modes de données (configurables dans Paramètres) :
- **Supabase** : utilise le backend Supabase si configuré et accessible. Nécessite une instance Supabase (locale ou distante).
- **Données de démonstration (InMemory)** : jeu de données fictif, clairement identifié, jamais écrit dans Supabase. Utile pour tester sans backend.

Si Supabase n'est pas initialisé ou non accessible, l'application bascule automatiquement en mode démo. Des scénarios de démo sont disponibles dans les paramètres (nominal, capteur périmé, sans mesures, commandes en attente, commande en erreur, installation vide).

## Tests

```bash
# Lancer tous les tests
flutter test

# Lancer les tests avec couverture
flutter test --coverage

# Lancer un fichier de test spécifique
flutter test test/unit/irrigation_rules_test.dart

# Vérifier l'analyse statique
flutter analyze
```

## Structure du projet

```
lib/
├── app/           # Configuration app (router, thème, providers)
├── core/          # Config, utilitaires, widgets communs
├── data/          # Implémentations repositories (Supabase, demo)
├── domain/        # Modèles, règles métier, contrats
├── features/      # Fonctionnalités (UI + logique)
├── shared/        # Composants partagés
└── main.dart      # Point d'entrée
```

## Ressources

- [Documentation Flutter](https://docs.flutter.dev/)
- [Documentation Riverpod](https://riverpod.dev/)
- [Documentation Supabase](https://supabase.com/docs)
- [Documentation go_router](https://pub.dev/packages/go_router)
