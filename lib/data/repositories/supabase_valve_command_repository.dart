import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/valve_command.dart';
import '../../domain/repositories/valve_command_repository.dart';

class SupabaseValveCommandRepository implements ValveCommandRepository {
  final SupabaseClient _client;

  SupabaseValveCommandRepository(this._client);

  @override
  Future<ValveCommand> requestOpen(
    String zoneId, {
    String? origin,
    String? reason,
  }) => _insert(zoneId, ValveCommandType.open, origin, reason);

  @override
  Future<ValveCommand> requestClose(
    String zoneId, {
    String? origin,
    String? reason,
  }) => _insert(zoneId, ValveCommandType.close, origin, reason);

  Future<ValveCommand> _insert(
    String zoneId,
    ValveCommandType type,
    String? origin,
    String? reason,
  ) async {
    try {
      final inserted = await _client
          .from('valve_commands')
          .insert({
            'zone_id': zoneId,
            'type': type.name,
            // La commande est toujours créée en attente : seule l'insertion
            // est décidée ici, l'exécution revient au contrôleur.
            'status': ValveCommandStatus.pending.name,
            'origin': origin ?? 'mobile_app',
            'reason': reason ?? 'manual',
            'requested_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      return ValveCommand.fromJson(inserted);
    } catch (e) {
      // Retry with minimal payload if schema differs
      final inserted = await _client
          .from('valve_commands')
          .insert({
            'zone_id': zoneId,
            'type': type.name,
            'status': ValveCommandStatus.pending.name,
            'origin': origin ?? 'mobile_app',
          })
          .select()
          .single();
      return ValveCommand.fromJson(inserted);
    }
  }

  @override
  Future<List<ValveCommand>> getHistory(String zoneId, {int limit = 20}) async {
    final data = await _client
        .from('valve_commands')
        .select()
        .eq('zone_id', zoneId)
        .order('requested_at', ascending: false)
        .limit(limit);
    return data.map((row) => ValveCommand.fromJson(row)).toList();
  }

  @override
  Future<List<ValveCommand>> getRecent({int limit = 50}) async {
    final data = await _client
        .from('valve_commands')
        .select()
        .order('requested_at', ascending: false)
        .limit(limit);
    return data.map((row) => ValveCommand.fromJson(row)).toList();
  }

  @override
  Future<ValveCommand?> getById(String commandId) async {
    final data = await _client
        .from('valve_commands')
        .select()
        .eq('id', commandId)
        .maybeSingle();
    if (data == null) return null;
    return ValveCommand.fromJson(data);
  }

  @override
  Stream<List<ValveCommand>> watchForZone(String zoneId) {
    return _client
        .from('valve_commands')
        .stream(primaryKey: ['id'])
        .eq('zone_id', zoneId)
        .order('requested_at', ascending: false)
        .map((rows) => rows.map((row) => ValveCommand.fromJson(row)).toList());
  }
}
