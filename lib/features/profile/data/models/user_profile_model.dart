// lib/features/profile/data/models/user_profile_model.dart
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.bio,
    super.profilePictureUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      name: json['full_name'], // Note: API might use 'full_name' but Entity uses 'name'
      email: json['email'],
      bio: json['bio'],
      profilePictureUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': name,
    'email': email,
    'bio': bio,
    'avatar_url': profilePictureUrl,
  };
}