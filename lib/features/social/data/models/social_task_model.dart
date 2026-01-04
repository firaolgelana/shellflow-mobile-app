import 'package:shell_flow_mobile_app/features/social/domain/entities/social_task.dart';

class SocialTaskModel extends SocialTask {
  SocialTaskModel({
    required super.id,
    required super.originalTaskId,
    required super.author,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.likeCount,
    required super.commentCount,
    required super.isLikedByMe,
  });
  factory SocialTaskModel.fromJson(Map<String, dynamic> json) {
    return SocialTaskModel(
      id: json['id'],
      originalTaskId: json['originalTaskId'],
      author: json['author'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      isLikedByMe: json['isLikedByMe'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalTaskId': originalTaskId,
      'author': author,
      'description': description,
      'createdAt': createdAt,
      'likeCount':likeCount,
      'commentCount':commentCount,
      'isLikedByMe':isLikedByMe
    };
  }
}
