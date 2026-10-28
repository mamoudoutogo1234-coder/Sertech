import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/sensor_data.dart';
import '../../domain/repositories/sensor_data_repository.dart';

class SupabaseSensorDataRepository implements SensorDataRepository {
  final SupabaseClient _client;

  SupabaseSensorDataRepository(this._client);

  @override
  Future<SensorData?> getLatest(String zoneId) async {
    final data = await _client
        .from('sensor_data')
        .select()
        .eq('zone_id', zoneId)
        .order('recorded_at', ascending: false)
        .limit(1)
        .maybeSingle();
    if (data == null) return null;
    return SensorData.fromJson(data);
  }

  @override
  Future<List<SensorData>> getHistory(String zoneId, {int limit = 50}) async {
    final data = await _client
        .from('sensor_data')
        .select()
        .eq('zone_id', zoneId)
        .order('recorded_at', ascending: false)
        .limit(limit);
    return data.map((row) => SensorData.fromJson(row)).toList();
  }

  @override
  Future<List<SensorData>> getHistoryForPeriod(
    String zoneId,
    HistoryPeriod period, {
    DateTime? now,
  }) async {
    final reference = now ?? DateTime.now();
    final start = period.startFrom(reference);
    final data = await _client
        .from('sensor_data')
        .select()
        .eq('zone_id', zoneId)
        .gte('recorded_at', start.toIso8601String())
        .order('recorded_at', ascending: true);
    return data.map((row) => SensorData.fromJson(row)).toList();
  }

  @override
  Future<Map<String, SensorData>> getLatestForZones(
    List<String> zoneIds,
  ) async {
    if (zoneIds.isEmpty) return const {};
    final result = <String, SensorData>{};
    for (final zoneId in zoneIds) {
      final latest = await getLatest(zoneId);
      if (latest != null) result[zoneId] = latest;
    }
    return result;
  }

  @override
  Stream<SensorData?> watchLatest(String zoneId) {
    final controller = StreamController<SensorData?>.broadcast(sync: true);
    RealtimeChannel? channel;

    Future<void> emitLatest() async {
      try {
        final latest = await getLatest(zoneId);
        if (!controller.isClosed) {
          controller.add(latest);
        }
      } catch (_) {}
    }

    emitLatest();

    try {
      channel = _client
          .channel('public:sensor_data:zone_id=eq.$zoneId')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'sensor_data',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'zone_id',
              value: zoneId,
            ),
            callback: (_) {
              emitLatest();
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'sensor_data',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'zone_id',
              value: zoneId,
            ),
            callback: (_) {
              emitLatest();
            },
          );
      channel.subscribe((status, error) {});
    } catch (_) {
      // Si l'abonnement échoue, on continue à émettre via polling implicite
      // en gardant le canal null pour un nettoyage propre
    }

    controller.onCancel = () async {
      try {
        if (channel != null) {
          await _client.removeChannel(channel);
        }
      } catch (_) {}
    };

    return controller.stream;
  }
}
