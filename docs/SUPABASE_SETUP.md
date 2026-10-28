# Supabase setup (local/dev)

- Supabase self-hosted on Raspberry Pi during development per project.
- Configure via environment variables at build/runtime: `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`.
- Use `lib/data/supabase/supabase_initializer.dart` to initialize.
- Realtime: repositories use Supabase streams where applicable (`watch*` methods).
- Offline-first: implementations tolerate missing config (fallback to in-memory). Sync resumes when connectivity returns.
- App never accesses hardware directly; commands go via Supabase → Raspberry Pi → MQTT.
