import 'package:shell_flow_mobile_app/features/social/domain/entities/social_comment.dart';

class SocialCommentModel extends SocialComment {
  SocialCommentModel({
    required super.id,
    required super.sharedTaskId,
    required super.author,
    required super.content,
    required super.timestamp,
  });
  factory SocialCommentModel.fromJson(Map<String, dynamic> json) {
    return SocialCommentModel(
      id: json['id'],
      sharedTaskId: json['sharedTaskId'],
      author: json['author'],
      content: json['content'],
      timestamp: json['timestamp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sharedTaskId': sharedTaskId,
      'author': author,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
