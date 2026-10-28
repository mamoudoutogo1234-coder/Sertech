import 'package:equatable/equatable.dart';

/// Profil utilisateur.
///
/// `id` correspond à `auth.users.id` : il n'existe pas de colonne
/// `user_id` dans la table `profiles`, le lien est direct.
class Profile extends Equatable {
  final String id;
  final String? displayName;
  final DateTime? createdAt;

  const Profile({required this.id, this.displayName, this.createdAt});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      displayName: json['display_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'display_name': displayName,
    'created_at': createdAt?.toIso8601String(),
  };

  Profile copyWith({String? id, String? displayName, DateTime? createdAt}) {
    return Profile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, displayName, createdAt];
}
