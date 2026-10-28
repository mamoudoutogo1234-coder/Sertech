import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';

/// Initialisation unique de Supabase.
///
/// L'échec d'initialisation n'est jamais fatal : l'application bascule sur le
/// mode de démonstration et reste utilisable hors ligne.
class SupabaseInitializer {
  SupabaseInitializer._();

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<bool> initialize() async {
    if (_initialized) return true;
    if (!AppConfig.hasSupabaseConfig) {
      return false;
    }
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        publishableKey: AppConfig.supabasePublishableKey,
      );
      _initialized = true;
      return true;
    } catch (error, stackTrace) {
      developer.log(
        'Supabase initialization failed; falling back to demo data.',
        name: 'Sertech.Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  static SupabaseClient get client {
    if (!_initialized) {
      throw StateError(
        'Supabase n\'est pas initialisé. Utilisez supabaseClientProvider '
        'plutôt que d\'accéder au client directement.',
      );
    }
    return Supabase.instance.client;
  }
}
