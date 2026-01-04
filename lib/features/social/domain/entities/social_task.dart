// features/social/domain/entities/social_task.dart

import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';

class SocialTask {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final SocialUser creator; // The SocialUser defined above
  final List<SocialUser> assignees;
  final int likeCount;
  final int commentCount;
  final bool isLikedByMe;

  SocialTask({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.creator,
    required this.assignees,
    required this.likeCount,
    required this.commentCount,
    required this.isLikedByMe,
  });
}