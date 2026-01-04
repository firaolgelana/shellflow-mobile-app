// domain/entities/shared_task.dart
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';

class SharedTask {
  final String id;
  final String originalTaskId; // Reference to the actual task ID
  final SocialUser author;
  final String title;
  final String description;
  final DateTime createdAt;
  
  // Social metrics
  final int likeCount;
  final int commentCount;
  final bool isLikedByMe;

  const SharedTask({
    required this.id,
    required this.originalTaskId,
    required this.author,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.isLikedByMe,
  });
}