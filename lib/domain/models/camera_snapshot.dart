import 'package:equatable/equatable.dart';

class CameraSnapshot extends Equatable {
  final String id;
  final String imageUrl;
  final DateTime capturedAt;
  final String? zoneId;

  const CameraSnapshot({
    required this.id,
    required this.imageUrl,
    required this.capturedAt,
    this.zoneId,
  });

  factory CameraSnapshot.fromJson(Map<String, dynamic> json) {
    return CameraSnapshot(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      capturedAt: DateTime.parse(json['captured_at'] as String),
      zoneId: json['zone_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image_url': imageUrl,
    'captured_at': capturedAt.toIso8601String(),
    'zone_id': zoneId,
  };

  @override
  List<Object?> get props => [id, imageUrl, capturedAt, zoneId];
}
