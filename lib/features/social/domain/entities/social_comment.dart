// domain/entities/social_comment.dart
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';

class SocialComment {
  final String id;
  final String sharedTaskId;
  final SocialUser author;
  final String content;
  final DateTime timestamp;

  const SocialComment({
    required this.id,
    required this.sharedTaskId,
    required this.author,
    required this.content,
    required this.timestamp,
  });
}