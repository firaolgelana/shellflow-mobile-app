import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/dashboard_data.dart';

class DashboardDataModel extends DashboardData {
  DashboardDataModel({
    required super.todayStats,
    required super.overallStats,
    required super.recentActivities,
    required super.weeklyProgress,
    required super.unreadNotificationCount,
  });
  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      todayStats: json['todayStats'],
      overallStats: json['overallStats'],
      recentActivities: json['recentActivities'],
      weeklyProgress: json['weeklyProgress'],
      unreadNotificationCount: json['unreadNotificationCount'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'todayStats': todayStats,
      'overallStats': overallStats,
      'recentActivities': recentActivities,
      'weeklyProgress': weeklyProgress,
      'unreadNotificationCount': unreadNotificationCount,
    };
  }
}
