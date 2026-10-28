import 'package:equatable/equatable.dart';

import '../rules/settings_validation.dart';

/// Paramètres d'automatisation d'une zone.
class IrrigationSettings extends Equatable {
  final String id;
  final String zoneId;
  final bool autoEnabled;
  final double startThreshold;
  final double stopThreshold;
  final int maxDurationSeconds;
  final int minIntervalSeconds;
  final DateTime? updatedAt;

  const IrrigationSettings({
    required this.id,
    required this.zoneId,
    required this.autoEnabled,
    required this.startThreshold,
    required this.stopThreshold,
    required this.maxDurationSeconds,
    required this.minIntervalSeconds,
    this.updatedAt,
  });

  factory IrrigationSettings.fromJson(Map<String, dynamic> json) {
    return IrrigationSettings(
      id: json['id'] as String,
      zoneId: json['zone_id'] as String,
      autoEnabled: (json['auto_enabled'] as bool?) ?? false,
      startThreshold: (json['start_threshold'] as num).toDouble(),
      stopThreshold: (json['stop_threshold'] as num).toDouble(),
      maxDurationSeconds: json['max_duration_seconds'] as int,
      minIntervalSeconds: json['min_interval_seconds'] as int,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'zone_id': zoneId,
    'auto_enabled': autoEnabled,
    'start_threshold': startThreshold,
    'stop_threshold': stopThreshold,
    'max_duration_seconds': maxDurationSeconds,
    'min_interval_seconds': minIntervalSeconds,
    'updated_at': updatedAt?.toIso8601String(),
  };

  IrrigationSettings copyWith({
    String? id,
    String? zoneId,
    bool? autoEnabled,
    double? startThreshold,
    double? stopThreshold,
    int? maxDurationSeconds,
    int? minIntervalSeconds,
    DateTime? updatedAt,
  }) {
    return IrrigationSettings(
      id: id ?? this.id,
      zoneId: zoneId ?? this.zoneId,
      autoEnabled: autoEnabled ?? this.autoEnabled,
      startThreshold: startThreshold ?? this.startThreshold,
      stopThreshold: stopThreshold ?? this.stopThreshold,
      maxDurationSeconds: maxDurationSeconds ?? this.maxDurationSeconds,
      minIntervalSeconds: minIntervalSeconds ?? this.minIntervalSeconds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Hystérésis : le seuil de démarrage doit être <= au seuil d'arrêt.
  bool get isHysteresisValid => startThreshold <= stopThreshold;

  bool get isValid => SettingsValidation.validate(this).isValid;

  @override
  List<Object?> get props => [
    id,
    zoneId,
    autoEnabled,
    startThreshold,
    stopThreshold,
    maxDurationSeconds,
    minIntervalSeconds,
    updatedAt,
  ];
}
