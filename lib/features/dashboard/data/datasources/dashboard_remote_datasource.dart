import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/profile/data/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; 
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/social_activity.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/weekly_progress.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart'; // Needed for DashboardData

abstract class DashboardRemoteDatasource {
  Future<DashboardData> getDashboardSummary(String userId);
  Future<List<SocialActivity>> getRecentSocialActivities(String userId);
  Future<TaskStatistics> getTaskStatistics(String userId); 
  Future<TaskStatistics> getDailyTaskStatistics(String userId);
  Future<int> getUnreadNotificationCount(String userId);
  Future<List<WeeklyProgress>> getWeeklyProgress(String userId);
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final SupabaseClient supabase;

  DashboardRemoteDatasourceImpl({required this.supabase});

  @override
  Future<DashboardData> getDashboardSummary(String userId) async {
    try {
      // PERFROMANCE OPTIMIZATION: Fetch all independent data in parallel
      final results = await Future.wait([
        _getUserProfile(userId),         // Index 0
        getDailyTaskStatistics(userId),  // Index 1
        getTaskStatistics(userId),       // Index 2 (Overall)
        getRecentSocialActivities(userId),// Index 3
        getUnreadNotificationCount(userId),// Index 4
        getWeeklyProgress(userId),       // Index 5
      ]);

      return DashboardData(
        userProfile: results[0] as UserProfile,
        todayStats: results[1] as TaskStatistics,
        overallStats: results[2] as TaskStatistics,
        recentActivities: results[3] as List<SocialActivity>,
        unreadNotificationCount: results[4] as int,
        weeklyProgress: results[5] as List<WeeklyProgress>,
      );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  // Helper method for the summary
  Future<UserProfile> _getUserProfile(String userId) async {
    final response = await supabase.from('profiles').select().eq('id', userId).single();
    return UserProfileModel.fromJson(response);
  }

  @override
  Future<TaskStatistics> getDailyTaskStatistics(String userId) async {
    try {
      final now = DateTime.now();
      // Start of day (00:00:00) and End of day (23:59:59)
      final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();

      // Fetch tasks for today
      final response = await supabase
          .from('tasks')
          .select('status')
          .eq('user_id', userId)
          .gte('due_date', startOfDay) // Assuming you filter by due_date
          .lte('due_date', endOfDay);

      return _calculateStatsFromList(response as List);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<TaskStatistics> getTaskStatistics(String userId) async {
    try {
      // Fetch ALL tasks for user
      final response = await supabase
          .from('tasks')
          .select('status')
          .eq('user_id', userId);

      return _calculateStatsFromList(response as List);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  // Helper to count status from a list of rows
  TaskStatistics _calculateStatsFromList(List<dynamic> tasks) {
    final int total = tasks.length;
    int completed = 0;
    int pending = 0;
    int inProgress = 0;

    for (var task in tasks) {
      final status = task['status'] as String;
      if (status == 'completed') {
        completed++;
      } else if (status == 'in_progress') {
        inProgress++;
      } else {
        pending++; // 'pending' or 'todo'
      }
    }

    return TaskStatistics(
      total: total,
      completed: completed,
      pending: pending,
      inProgress: inProgress,
    );
  }

  @override
  Future<List<SocialActivity>> getRecentSocialActivities(String userId) async {
    try {
      // Assuming a 'notifications' table acts as the activity log
      final response = await supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(5);

      return (response as List).map((e) {
        return SocialActivity(
          id: e['id'],
          description: e['content'] ?? 'New interaction',
          timestamp: DateTime.parse(e['created_at']),
          type: e['type'] ?? 'general',
        );
      }).toList();
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final count = await supabase
          .from('notifications')
          .count(CountOption.exact)
          .eq('user_id', userId)
          .eq('is_read', false);

      return count; 
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<WeeklyProgress>> getWeeklyProgress(String userId) async {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      // Fetch tasks from last 7 days
      final response = await supabase
          .from('tasks')
          .select('status, due_date') // Need date to group by day
          .eq('user_id', userId)
          .gte('due_date', sevenDaysAgo.toIso8601String());

      // Process in Dart (Group by Day)
      // This map will hold: "Mon" -> {total: 5, completed: 3}
      final Map<String, Map<String, int>> weeklyMap = {};

      // Initialize last 7 days with 0
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dayName = DateFormat('E').format(date); // Mon, Tue
        weeklyMap[dayName] = {'total': 0, 'completed': 0};
      }

      for (var task in response) {
        final dateStr = task['due_date'];
        if (dateStr != null) {
          final date = DateTime.parse(dateStr);
          final dayName = DateFormat('E').format(date);
          
          if (weeklyMap.containsKey(dayName)) {
            weeklyMap[dayName]!['total'] = weeklyMap[dayName]!['total']! + 1;
            if (task['status'] == 'completed') {
              weeklyMap[dayName]!['completed'] = weeklyMap[dayName]!['completed']! + 1;
            }
          }
        }
      }

      // Convert Map to List<WeeklyProgress>
      final List<WeeklyProgress> progressList = [];
      weeklyMap.forEach((day, stats) {
        double rate = 0.0;
        if (stats['total']! > 0) {
          rate = stats['completed']! / stats['total']!;
        }
        progressList.add(WeeklyProgress(
          dayName: day,
          completionRate: rate,
          tasksCompleted: stats['completed']!,
        ));
      });

      return progressList;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}