import 'package:equatable/equatable.dart';

/// Zone de culture : une parcelle physique pilotée par une électrovanne.
///
/// Ce n'est pas un appareil : une zone peut regrouper plusieurs capteurs.
class Zone extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Zone({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: (json['is_active'] as bool?) ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'description': description,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  Zone copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Zone(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
}
