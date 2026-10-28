import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/irrigation_settings.dart';
import '../../domain/repositories/irrigation_settings_repository.dart';

class SupabaseIrrigationSettingsRepository
    implements IrrigationSettingsRepository {
  final SupabaseClient _client;

  SupabaseIrrigationSettingsRepository(this._client);

  @override
  Future<IrrigationSettings?> getForZone(String zoneId) async {
    final data = await _client
        .from('irrigation_settings')
        .select()
        .eq('zone_id', zoneId)
        .maybeSingle();
    if (data == null) return null;
    return IrrigationSettings.fromJson(data);
  }

  @override
  Future<Map<String, IrrigationSettings>> getAll() async {
    final data = await _client.from('irrigation_settings').select();
    return {
      for (final row in data)
        row['zone_id'] as String: IrrigationSettings.fromJson(row),
    };
  }

  @override
  Future<void> upsert(IrrigationSettings settings) async {
    try {
      await _client
          .from('irrigation_settings')
          .upsert(
            {
              'id': settings.id,
              'zone_id': settings.zoneId,
              'auto_enabled': settings.autoEnabled,
              'start_threshold': settings.startThreshold,
              'stop_threshold': settings.stopThreshold,
              'max_duration_seconds': settings.maxDurationSeconds,
              'min_interval_seconds': settings.minIntervalSeconds,
            },
            onConflict: 'zone_id',
            ignoreDuplicates: false,
          )
          .select();
      return;
    } catch (error, stackTrace) {
      developer.log(
        'IrrigationSettings upsert attempt 1 failed, trying update',
        name: 'Sertech.IrrigationSettings',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      final updated = await _client
          .from('irrigation_settings')
          .update({
            'auto_enabled': settings.autoEnabled,
            'start_threshold': settings.startThreshold,
            'stop_threshold': settings.stopThreshold,
            'max_duration_seconds': settings.maxDurationSeconds,
            'min_interval_seconds': settings.minIntervalSeconds,
          })
          .eq('zone_id', settings.zoneId)
          .select();
      if (updated.isNotEmpty) return;
    } catch (error, stackTrace) {
      developer.log(
        'IrrigationSettings upsert attempt 2 failed, trying insert',
        name: 'Sertech.IrrigationSettings',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      await _client
          .from('irrigation_settings')
          .insert({
            'id': settings.id,
            'zone_id': settings.zoneId,
            'auto_enabled': settings.autoEnabled,
            'start_threshold': settings.startThreshold,
            'stop_threshold': settings.stopThreshold,
            'max_duration_seconds': settings.maxDurationSeconds,
            'min_interval_seconds': settings.minIntervalSeconds,
          })
          .select();
      return;
    } catch (error, stackTrace) {
      developer.log(
        'IrrigationSettings upsert attempt 3 failed, trying minimal upsert',
        name: 'Sertech.IrrigationSettings',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      await _client
          .from('irrigation_settings')
          .upsert({
            'zone_id': settings.zoneId,
            'auto_enabled': settings.autoEnabled,
            'start_threshold': settings.startThreshold,
            'stop_threshold': settings.stopThreshold,
            'max_duration_seconds': settings.maxDurationSeconds,
            'min_interval_seconds': settings.minIntervalSeconds,
          }, onConflict: 'zone_id')
          .select();
      return;
    } catch (e, st) {
      developer.log(
        'IrrigationSettings upsert failed after all fallbacks',
        name: 'Sertech.IrrigationSettings',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  Future<void> delete(String zoneId) async {
    await _client.from('irrigation_settings').delete().eq('zone_id', zoneId);
  }
}
