import 'package:equatable/equatable.dart';

/// Mesure d'humidité d'une zone, telle qu'écrite par le Raspberry Pi.
///
/// `moistureRaw` est la valeur brute du capteur (FC-28-DC), `moisturePercent`
/// est le pourcentage calibré. Les deux sont conservés distincts : aucune
/// conversion arbitraire n'est appliquée côté application.
class SensorData extends Equatable {
  final String id;
  final String zoneId;
  final DateTime recordedAt;
  final double? moistureRaw;
  final double? moisturePercent;
  final String? source;
  final Map<String, dynamic>? metadata;

  const SensorData({
    required this.id,
    required this.zoneId,
    required this.recordedAt,
    this.moistureRaw,
    this.moisturePercent,
    this.source,
    this.metadata,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'] as String,
      zoneId: json['zone_id'] as String,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      moistureRaw: (json['moisture_raw'] as num?)?.toDouble(),
      moisturePercent: (json['moisture_percent'] as num?)?.toDouble(),
      source: json['source'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'zone_id': zoneId,
    'recorded_at': recordedAt.toIso8601String(),
    'moisture_raw': moistureRaw,
    'moisture_percent': moisturePercent,
    'source': source,
    'metadata': metadata,
  };

  /// La mesure est-elle calibrée en pourcentage ?
  bool get isCalibrated => moisturePercent != null;

  /// Mesure sans valeur exploitable.
  bool get hasValue => moisturePercent != null || moistureRaw != null;

  /// La mesure est-elle hors de l'intervalle plausible (0-100 %) ?
  bool get isOutOfRange =>
      moisturePercent != null &&
      (moisturePercent! < 0 || moisturePercent! > 100);

  @override
  List<Object?> get props => [
    id,
    zoneId,
    recordedAt,
    moistureRaw,
    moisturePercent,
    source,
    metadata,
  ];
}
