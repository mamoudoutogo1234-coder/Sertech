import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../domain/models/profile.dart';

/// Session Supabase courante.
///
/// En mode démonstration, l'application n'exige aucune authentification :
/// le flux renvoie simplement `null` et n'ouvre aucune connexion.
final authSessionProvider = StreamProvider<Session?>((ref) {
  if (ref.watch(effectiveDataModeProvider) != DataMode.supabase) {
    return Stream<Session?>.value(null);
  }
  final client = ref.watch(supabaseClientProvider);
  if (client == null) {
    return Stream<Session?>.value(null);
  }
  Stream<Session?> stream() async* {
    yield client.auth.currentSession;
    yield* client.auth.onAuthStateChange.map((event) => event.session);
  }

  return stream();
});

final isSignedInProvider = Provider<bool>((ref) {
  if (ref.watch(effectiveDataModeProvider) == DataMode.inMemory) return true;
  return ref.watch(authSessionProvider).valueOrNull != null;
});

/// Profil de l'utilisateur connecté.
final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  if (!ref.watch(isSignedInProvider)) return null;
  ref.watch(authSessionProvider);
  return ref.watch(profileRepositoryProvider).getCurrentProfile();
});

final authControllerProvider = Provider<AuthController>(
  (ref) => AuthController(ref),
);

class AuthController {
  AuthController(this.ref);

  final Ref ref;

  /// Client Supabase utilisable, sinon une erreur explicite.
  ///
  /// En mode démonstration, aucune méthode d'authentification ne doit être
  /// appelée : l'interface masque ces actions et ce garde-fou protège les
  /// appels résiduels.
  SupabaseClient _requireClient() {
    final client = ref.read(supabaseClientProvider);
    if (ref.read(effectiveDataModeProvider) != DataMode.supabase ||
        client == null) {
      throw StateError(
        'Authentification indisponible en mode démonstration ou lorsque '
        'Supabase n\'est pas initialisé.',
      );
    }
    return client;
  }

  Future<void> signIn({required String email, required String password}) async {
    await _requireClient().auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    ref.invalidate(currentProfileProvider);
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _requireClient().auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        if (displayName != null && displayName.trim().isNotEmpty)
          'display_name': displayName.trim(),
      },
    );
    final user = response.user;
    if (user != null) {
      await ref
          .read(profileRepositoryProvider)
          .upsertProfile(userId: user.id, displayName: displayName);
    }
    ref.invalidate(currentProfileProvider);
  }

  /// Déconnexion sûre : sans session Supabase (mode démo), l'appel ne fait
  /// qu'invalider le profil local et ne touche jamais au client.
  Future<void> signOut() async {
    final client = ref.read(supabaseClientProvider);
    if (ref.read(effectiveDataModeProvider) == DataMode.supabase &&
        client != null) {
      await client.auth.signOut();
    }
    ref.invalidate(currentProfileProvider);
  }
}
