import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient _client;

  SupabaseProfileRepository(this._client);

  @override
  Future<Profile?> getCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    return Profile.fromJson(data);
  }

  @override
  Future<Profile> upsertProfile({
    required String userId,
    String? displayName,
  }) async {
    final data = await _client
        .from('profiles')
        .upsert({'id': userId, 'display_name': displayName})
        .select()
        .single();
    return Profile.fromJson(data);
  }
}
