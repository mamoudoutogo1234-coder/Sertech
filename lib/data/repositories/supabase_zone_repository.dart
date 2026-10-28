import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/zone.dart';
import '../../domain/repositories/zone_repository.dart';

class SupabaseZoneRepository implements ZoneRepository {
  final SupabaseClient _client;

  SupabaseZoneRepository(this._client);

  @override
  Future<List<Zone>> getZones() async {
    final data = await _client
        .from('zones')
        .select()
        .order('created_at', ascending: true);
    return data.map((row) => Zone.fromJson(row)).toList();
  }

  @override
  Future<Zone?> getZone(String zoneId) async {
    final data = await _client
        .from('zones')
        .select()
        .eq('id', zoneId)
        .maybeSingle();
    if (data == null) return null;
    return Zone.fromJson(data);
  }

  @override
  Future<Zone> createZone({
    required String userId,
    required String name,
    String? description,
    bool isActive = true,
  }) async {
    final inserted = await _client
        .from('zones')
        .insert({
          'user_id': userId,
          'name': name,
          'description': description,
          'is_active': isActive,
        })
        .select()
        .single();
    return Zone.fromJson(inserted);
  }

  @override
  Future<Zone> updateZone(Zone zone) async {
    final updated = await _client
        .from('zones')
        .update({
          'name': zone.name,
          'description': zone.description,
          'is_active': zone.isActive,
        })
        .eq('id', zone.id)
        .select()
        .single();
    return Zone.fromJson(updated);
  }

  @override
  Future<void> deleteZone(String zoneId) async {
    await _client.from('zones').delete().eq('id', zoneId);
  }
}
