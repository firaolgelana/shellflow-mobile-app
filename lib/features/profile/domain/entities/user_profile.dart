import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? username;
  final String? bio;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final DateTime? createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.bio,
    this.profilePictureUrl,
    this.phoneNumber,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    bio,
    profilePictureUrl,
    phoneNumber,
    createdAt,
  ];
}
