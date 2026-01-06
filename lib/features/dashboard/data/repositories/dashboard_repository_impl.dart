import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/core/network/network_info.dart';
import 'package:shell_flow_mobile_app/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/social_activity.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/upcoming_task.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/weekly_progress.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  DashboardRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, TaskStatistics>> getDailyTaskStatistics(
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = remoteDatasource.getDailyTaskStatistics(userId);
        return Right(await result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, DashboardData>> getDashboardSummary(String userId) async{
    if (await networkInfo.isConnected) {
      try {
        final result = remoteDatasource.getDashboardSummary(userId);
        return Right(await result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<SocialActivity>>> getRecentSocialActivities(
    String userId,
  )async {
    if (await networkInfo.isConnected) {
      try {
        final result = remoteDatasource.getRecentSocialActivities(userId);
        return Right(await result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, TaskStatistics>> getTaskStatistics(String userId) async{
    if (await networkInfo.isConnected) {
      try {
        final result = remoteDatasource.getTaskStatistics(userId);
        return Right(await result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadNotificationCount(String userId) async{
    if (await networkInfo.isConnected) {
      try {
        final result = remoteDatasource.getUnreadNotificationCount(userId);
        return Right(await result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<WeeklyProgress>>> getWeeklyProgress(
    String userId,
  ) async{
    if (await networkInfo.isConnected) {
      try {
        final result = remoteDatasource.getWeeklyProgress(userId);
        return Right(await result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<UpcomingTask>>> getUpComingTasks(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = remoteDatasource.getUpcomingTasks(userId);
        return Right(await result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
