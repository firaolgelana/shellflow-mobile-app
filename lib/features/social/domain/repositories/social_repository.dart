import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart'; 
import 'package:shell_flow_mobile_app/features/social/domain/entities/connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_task.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';
enum ConnectionRequestAction { accept, decline }
abstract class SocialRepository {
  Future<Either<Failure, SocialComment>> addComment({
    required String taskId,
    required String content,
  });
  Future<Either<Failure, void>> deleteComment({
    required String commentId,
  });
  Future<Either<Failure, List<SocialUser>>> getFriendList({
    String? userId,
  });
  Future<Either<Failure, List<ConnectionRequest>>> getPendingRequests();
  Future<Either<Failure, List<SocialTask>>> getSocialFeed({
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, UserProfile>> getSocialUserProfile({
    required String userId,
  });
  Future<Either<Failure, List<SocialComment>>> getTaskComments({
    required String taskId,
  });
  Future<Either<Failure, void>> handleConnectionRequest({
    required String requestId,
    required ConnectionRequestAction action,
  });
  Future<Either<Failure, void>> removeFriend({
    required String friendId,
  });
  Future<Either<Failure, List<SocialUser>>> searchUsers({
    required String query,
  });
  Future<Either<Failure, ConnectionRequest>> sendConnectionRequest({
    required String targetUserId,
  });
  Future<Either<Failure, SocialTask>> shareTaskToFeed({
    required String taskId,
    String? caption,
  });
  Future<Either<Failure, void>> toggleLikeTask({
    required String taskId,
  });
  Future<Either<Failure, SocialTask>> getSharedTaskDetails({
    required String taskId,
  });
}