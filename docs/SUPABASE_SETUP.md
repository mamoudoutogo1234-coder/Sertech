# Supabase setup (local/dev)

- Supabase self-hosted on Raspberry Pi during development per project.
- Configure via environment variables at build/runtime: `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`.
- Use `lib/data/supabase/supabase_initializer.dart` to initialize.
- **Realtime** : `public.sensor_data` est ajouté à la publication `supabase_realtime` avec `REPLICA IDENTITY FULL`. L'application s'abonne aux événements `INSERT`/`UPDATE` filtrés par `zone_id` via `onPostgresChanges`. Le tableau de bord et l'historique se mettent à jour automatiquement sans actualisation manuelle.
- Offline-first: implementations tolerate missing config (fallback to in-memory). Sync resumes when connectivity returns.
- App never accesses hardware directly; commands go via Supabase → Raspberry Pi → MQTT.
- RLS reste activé. Utiliser uniquement la clé `publishable`/`anon` côté Flutter. Ne jamais ajouter de clé `service_role`.
