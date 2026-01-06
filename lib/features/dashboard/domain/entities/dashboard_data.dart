import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/social_activity.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/upcoming_task.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/weekly_progress.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';

class DashboardData {
  final UserProfile userProfile;
  final TaskStatistics todayStats;
  final TaskStatistics overallStats;
  final List<SocialActivity> recentActivities;
  final List<WeeklyProgress> weeklyProgress;
  final List<UpcomingTask> upcomingTasks;
  final int unreadNotificationCount;

  DashboardData({
    required this.userProfile,
    required this.todayStats,
    required this.overallStats,
    required this.recentActivities,
    required this.weeklyProgress,
    required this.unreadNotificationCount,
    required this.upcomingTasks,
  });
    // --- ADD THIS METHOD ---
  DashboardData copyWith({
  UserProfile? userProfile,
  TaskStatistics? todayStats,
  TaskStatistics? overallStats,
  List<SocialActivity>? recentActivities,
  List<WeeklyProgress>? weeklyProgress,
  List<UpcomingTask>? upcomingTasks,
  int? unreadNotificationCount,

  }) {
    return DashboardData(
      userProfile: userProfile ?? this.userProfile,
      todayStats: todayStats ?? this.todayStats,
      overallStats: overallStats ?? this.overallStats,
      upcomingTasks: upcomingTasks ?? this.upcomingTasks,
      recentActivities: recentActivities ?? this.recentActivities,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      unreadNotificationCount: unreadNotificationCount ?? this.unreadNotificationCount
    );
  }
}
