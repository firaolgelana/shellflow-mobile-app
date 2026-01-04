import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';

class SocialUserModel extends SocialUser {
  SocialUserModel({
    required super.id,
    required super.username,
    required super.photoUrl,
  });

  factory SocialUserModel.fromJson(Map<String, dynamic> json) {
    return SocialUserModel(
      id: json['id'],
      username: json['username'],
      photoUrl: json['photoUrl'],
    );
  }
  Map<String, dynamic> json() {
    return {'id': id, 'username': username, 'photoUrl': photoUrl};
  }
}
