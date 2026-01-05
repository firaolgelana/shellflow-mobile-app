import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/social_activity.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/weekly_progress.dart';

class DashboardData {
  final TaskStatistics todayStats;
  final TaskStatistics overallStats;
  final List<SocialActivity> recentActivities;
  final List<WeeklyProgress> weeklyProgress;
  final int unreadNotificationCount;

  DashboardData({
    required this.todayStats,
    required this.overallStats,
    required this.recentActivities,
    required this.weeklyProgress,
    required this.unreadNotificationCount,
  });
}

