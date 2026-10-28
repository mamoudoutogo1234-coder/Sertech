# Modèle de données

Ce document décrit les modèles de domaine utilisés par l'application Sertech. Les modèles sont définis dans `lib/domain/models/` en Dart pur (immutable, `Equatable`), avec `fromJson`/`toJson` pour la sérialisation compatible Supabase.

## Modèles de domaine

### Zone
Représente une zone de culture pilotée par une électrovanne. Une zone peut regrouper plusieurs capteurs.

**Fichier** : `lib/domain/models/zone.dart`

| Champ | Type | Description |
|-------|------|-------------|
| `id` | `String` | Identifiant unique (UUID) |
| `userId` | `String` | Propriétaire de la zone (référence `auth.users`) |
| `name` | `String` | Nom de la zone |
| `description` | `String?` | Description optionnelle |
| `isActive` | `bool` | Zone active/inactive (défaut: `true`) |
| `createdAt` | `DateTime?` | Date de création |
| `updatedAt` | `DateTime?` | Date de mise à jour |

### SensorData
Données de mesure provenant des capteurs (humidité du sol).

**Fichier** : `lib/domain/models/sensor_data.dart`

| Champ | Type | Description |
|-------|------|-------------|
| `id` | `String` | Identifiant unique |
| `zoneId` | `String` | Référence vers la zone |
| `recordedAt` | `DateTime?` | Horodatage de la mesure |
| `moistureRaw` | `double?` | Valeur brute du capteur |
| `moisturePercent` | `double?` | Humidité normalisée en pourcentage (0-100) |
| `source` | `String?` | Source de la mesure (ex: capteur, manuel) |
| `metadata` | `Map<String, dynamic>?` | Métadonnées additionnelles |

### IrrigationSettings
Paramètres d'automatisation pour une zone. Appliquent une logique d'hystérésis.

**Fichier** : `lib/domain/models/irrigation_settings.dart`

| Champ | Type | Description |
|-------|------|-------------|
| `id` | `String` | Identifiant unique |
| `zoneId` | `String` | Référence vers la zone (unique) |
| `autoEnabled` | `bool` | Automatisation activée/désactivée |
| `startThreshold` | `double` | Seuil de démarrage de l'irrigation (%) |
| `stopThreshold` | `double` | Seuil d'arrêt de l'irrigation (%) |
| `maxDurationSeconds` | `int` | Durée maximale d'irrigation (secondes) |
| `minIntervalSeconds` | `int` | Intervalle minimum entre deux arrosages (secondes) |
| `updatedAt` | `DateTime?` | Date de mise à jour |

**Règles** : `startThreshold <= stopThreshold` (hystérésis). Validé par `SettingsValidation`.

### ValveCommand
Commande envoyée à l'électrovanne d'une zone (manuelle ou automatique).

**Fichier** : `lib/domain/models/valve_command.dart`

| Champ | Type | Description |
|-------|------|-------------|
| `id` | `String` | Identifiant unique |
| `zoneId` | `String` | Référence vers la zone |
| `type` | `ValveCommandType` | Type de commande : `open` ou `close` |
| `status` | `ValveCommandStatus` | État : `pending`, `executing`, `executed`, `failed` |
| `origin` | `String?` | Origine (ex: `manual`, `automation`) |
| `reason` | `String?` | Raison de la commande |
| `requestedAt` | `DateTime?` | Date de demande |
| `executedAt` | `DateTime?` | Date d'exécution |
| `errorMessage` | `String?` | Message d'erreur en cas d'échec |

**Enums** :
- `ValveCommandType { open, close }`
- `ValveCommandStatus { pending, executing, executed, failed }`

### Profile
Profil utilisateur.

**Fichier** : `lib/domain/models/profile.dart`

| Champ | Type | Description |
|-------|------|-------------|
| `id` | `String` | Identifiant (référence `auth.users`) |
| `displayName` | `String?` | Nom affiché |

### CameraSnapshot
Instantané caméra (fonctionnalité en cours / non disponible selon configuration).

**Fichier** : `lib/domain/models/camera_snapshot.dart`

| Champ | Type | Description |
|-------|------|-------------|
| `id` | `String` | Identifiant unique |
| `zoneId` | `String?` | Zone associée |
| `imageUrl` | `String` | URL de l'image |
| `capturedAt` | `DateTime` | Date de capture |

### AutomationState
État de l'automatisation (utilisé par le domaine/contrôleur).

**Fichier** : `lib/domain/models/automation_state.dart`

Représente l'état courant lié à l'automatisation d'irrigation.

## Schéma Supabase

Les tables correspondent aux modèles ci-dessus avec les noms snake_case dans la base de données. Mapping effectué via `fromJson`/`toJson`.

Tables définies dans `supabase/migrations/20251015000000_init_sertech.sql` :
- `profiles` (liée à `auth.users`)
- `zones`
- `sensor_data`
- `irrigation_settings`
- `valve_commands`

Contraintes importantes :
- Hystérésis : `irrigation_settings.start_threshold <= stop_threshold`
- Humidité : `moisture_raw >= 0`, `moisture_percent` entre 0-100
- Commandes : `type` dans `('open','close')`, `status` dans `('pending','executing','executed','failed')`
- RLS activé avec politiques basées sur la propriété (`auth.uid()`)

## Fraîcheur des données

- Fenêtre de fraîcheur : `AppConfig.readingFreshnessWindow = Duration(minutes: 30)`
- Fenêtre maximale pour décision d'arrosage : `IrrigationRules.maxMeasurementAge = Duration(minutes: 30)`
- Les données périmées ou absentes ne doivent pas être utilisées pour déclencher l'automatisation
- L'interface doit afficher des états explicites (vide/périmé) pour éviter une fausse représentation des mesures

## DTOs

Les implémentations Supabase dans `lib/data/repositories/` manipulent directement les lignes Supabase et utilisent les modèles de domaine pour le mapping. Il n'y a pas de DTOs séparés dans `lib/data/models/` dans l'état actuel du projet.
