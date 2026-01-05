import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/social_activity.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/weekly_progress.dart';
abstract class DashboardRepository {
  Future<Either<Failure, DashboardData>> getDashboardSummary(String userId);
  Future<Either<Failure, List<SocialActivity>>> getRecentSocialActivities(String userId);
  Future<Either<Failure, TaskStatistics>> getTaskStatistics(String userId); 
  Future<Either<Failure, TaskStatistics>> getDailyTaskStatistics(String userId);
  Future<Either<Failure, int>> getUnreadNotificationCount(String userId);
  Future<Either<Failure, List<WeeklyProgress>>> getWeeklyProgress(String userId);
}