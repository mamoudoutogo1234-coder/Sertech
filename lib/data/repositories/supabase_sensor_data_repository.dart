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
    return _client
        .from('sensor_data')
        .stream(primaryKey: ['id'])
        .eq('zone_id', zoneId)
        .order('recorded_at', ascending: false)
        .limit(1)
        .map((rows) => rows.isEmpty ? null : SensorData.fromJson(rows.first));
  }
}
