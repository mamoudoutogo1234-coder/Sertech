import '../models/profile.dart';

/// Contrat d'accès au profil de l'utilisateur connecté.
///
/// Le profil estoptionnel : l'application reste utilisable sans profil,
/// mais aucune donnée n'est alors attribuée à un utilisateur arbitraire.
abstract class ProfileRepository {
  Future<Profile?> getCurrentProfile();

  Future<Profile> upsertProfile({required String userId, String? displayName});
}
