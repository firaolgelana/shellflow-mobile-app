import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';

abstract class SocialRepository {
  Future<Either<Failure, SocialComment>> addComment();
  Future<Either<Failure, void>> deleteComment();
  Future<Either<Failure, List<SocialUser>>> getFriendList();
  Future<Either<Failure, ConnectionRequest>> getPendingRequests();
  Future<Either<Failure, List<SocialUser>>> getSocialFeed();
  Future<Either<Failure, UserProfile>> getSocialUserProfile();
  Future<Either<Failure, SocialComment>> getSocialComment();
  Future<Either<Failure, ConnectionRequest>> handleConnectionRequests();
  Future<Either<Failure, void>> removeFriend();
  Future<Either<Failure, SocialUser>> searchUsers();
  Future<Either<Failure, ConnectionRequest>> sendConnectionRequest();
  Future<Either<Failure, SocialUser>> shareTaskToFeed();
  Future<Either<Failure, SocialUser>> toggleLikeTask();
}