class AppConfig {
  AppConfig._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'http://127.0.0.1:54321',
  );
  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH',
  );

  static bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  static const Duration readingFreshnessWindow = Duration(minutes: 30);
}
