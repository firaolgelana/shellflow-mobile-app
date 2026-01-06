import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/dashboard_data.dart';

class DashboardDataModel extends DashboardData {
  DashboardDataModel({
    required super.userProfile,
    required super.todayStats,
    required super.overallStats,
    required super.recentActivities,
    required super.weeklyProgress,
    required super.upcomingTasks,
    required super.unreadNotificationCount,
  });
  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      userProfile: json['userProfile'],
      todayStats: json['todayStats'],
      overallStats: json['overallStats'],
      recentActivities: json['recentActivities'],
      weeklyProgress: json['weeklyProgress'],
      unreadNotificationCount: json['unreadNotificationCount'],
      upcomingTasks: json['upcomingTasks'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userProfile':userProfile,
      'todayStats': todayStats,
      'overallStats': overallStats,
      'recentActivities': recentActivities,
      'weeklyProgress': weeklyProgress,
      'unreadNotificationCount': unreadNotificationCount,
      'upcomingTasks': upcomingTasks,
    };
  }
}
