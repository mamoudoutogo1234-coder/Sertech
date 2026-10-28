# Architecture (Sertech Mobile)

## Principles
- Separation: Presentation → Application → Domain → Data
- Widgets must not call Supabase/remote directly; use Riverpod providers/repositories
- Domain models have no dependencies on Flutter/Supabase
- Data access is injectable (mockable for tests)
- Offline-first: app logic remains usable without Supabase; sync resumes later

## Data flow (mandated)
- Measures: ESP32 → MQTT (local) → Raspberry Pi → Supabase → App
- Commands: App → Supabase → Raspberry Pi → MQTT (local) → hardware
- Automation is independent of mobile device
- **Realtime** : Le dashboard écoute les nouvelles mesures via Supabase Realtime (`sensor_data` filtré par `zone_id`). Les mises à jour sont fusionnées dans les providers Riverpod pour un rafraîchissement automatique.

## Folders
- `lib/app/`: theme, router, app, providers (infrastructure wiring)
- `lib/core/`: config, errors, network, utils, widgets
- `lib/domain/`: models (immutable, Equatable), repository contracts
- `lib/data/`: DTOs + repository implementations (Supabase-based) + in-memory fixtures
- `lib/features/*/`: presentation (screens/widgets), application (providers/controllers)
- `lib/shared/`: shared widgets/formatters

## State management (Riverpod)
- Providers registered in `app/providers.dart`
- Feature-specific providers/controllers under `features/*/application/`
