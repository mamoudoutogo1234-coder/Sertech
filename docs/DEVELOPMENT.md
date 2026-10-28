# Development

Commands (exact):
- `flutter pub get` — after pubspec changes
- `flutter analyze` — must pass before committing
- `dart format --set-exit-if-changed .` — if CI enforces
- `flutter test` — all tests
- `flutter test test/path/to_test.dart` — single test
- `flutter run` — specify device if needed

Recommended order: `flutter pub get` (if needed) → `flutter analyze` → `flutter test`

## Design system

- Source of truth: `lib/app/theme/` (`app_colors.dart`, `app_typography.dart`, `app_spacing.dart`, `app_motion.dart`, `app_theme.dart`).
- Five destinations: Accueil, Zones, Mesures, Irrigation, Activité. Caméra is a secondary route.
- Typescale: 48 / 24 / 16 / 12, weights 400 / 600, Manrope bundled in `assets/fonts/`.
- Palette derived from the logo: primary `#0A723B`, deep `#044B2D`, leaf `#4EB427`, water `#0173AE`, teal `#0A868D`, dark background `#07110C`.
- Never hard-code a color, radius or font size in a widget when a token exists.
- No images without validation. The dashboard must stay useful without images.

## Brand assets

Source files stay in `assets/`:
- `assets/icon.png` — launcher icon source.
- `assets/Splash Screen.png` — splash source.

Generated derivatives live in `assets/brand/` and are produced by:

```bash
python3 tool/generate_brand_assets.py
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

`tool/generate_brand_assets.py` requires Pillow. Do not edit generated native files by hand
(`mipmap-*`, `drawable*`, `values-v31`, `LaunchScreen.storyboard`, `AppIcon.appiconset`).
Only `flutter_launcher_icons.yaml` and `flutter_native_splash.yaml` are sources of truth.

## Data modes

- `DataMode.supabase` — real Supabase reads/writes through the repositories.
- `DataMode.inMemory` — explicit demo data, never written to Supabase.
- `dataModeProvider` stores the user preference; `effectiveDataModeProvider` is the mode actually
  applied (it falls back to demo when no Supabase client is available).
- All repositories watch `effectiveDataModeProvider` and `supabaseClientProvider`.
- Demo sign-out is a safe no-op; authentication actions require a real Supabase client.
