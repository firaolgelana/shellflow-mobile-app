import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/core/network/network_info.dart'; 
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/social/data/datasources/social_remote_datasource.dart'; 
import 'package:shell_flow_mobile_app/features/social/domain/entities/connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_task.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class SocialRepositoryImpl implements SocialRepository {
  final SocialRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  SocialRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SocialComment>> addComment({
    required String taskId,
    required String content,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.addComment(
          taskId: taskId,
          content: content,
        );
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({required String commentId}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.deleteComment(commentId: commentId);
        return const Right(null);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<SocialUser>>> getFriendList({String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getFriendList(userId: userId);
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<ConnectionRequest>>> getPendingRequests() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getPendingRequests();
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, SocialTask>> getSharedTaskDetails({
    required String taskId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getSharedTaskDetails(taskId: taskId);
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<SocialTask>>> getSocialFeed({
    int page = 1,
    int limit = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getSocialFeed(
          page: page,
          limit: limit,
        );
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getSocialUserProfile({
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getSocialUserProfile(userId: userId);
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<SocialComment>>> getTaskComments({
    required String taskId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getTaskComments(taskId: taskId);
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> handleConnectionRequest({
    required String requestId,
    required ConnectionRequestAction action,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.handleConnectionRequest(
          requestId: requestId,
          action: action,
        );
        return const Right(null);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFriend({required String friendId}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.removeFriend(friendId: friendId);
        return const Right(null);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<SocialUser>>> searchUsers({
    required String query,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.searchUsers(query: query);
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, ConnectionRequest>> sendConnectionRequest({
    required String targetUserId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.sendConnectionRequest(
          targetUserId: targetUserId,
        );
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, SocialTask>> shareTaskToFeed({
    required String taskId,
    String? caption,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.shareTaskToFeed(
          taskId: taskId,
          caption: caption,
        );
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleLikeTask({required String taskId}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.toggleLikeTask(taskId: taskId);
        return const Right(null);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }
}