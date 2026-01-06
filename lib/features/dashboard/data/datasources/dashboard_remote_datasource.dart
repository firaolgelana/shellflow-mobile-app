import 'package:flutter/foundation.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/upcoming_task.dart';
import 'package:shell_flow_mobile_app/features/profile/data/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/social_activity.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/weekly_progress.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';

abstract class DashboardRemoteDatasource {
  Future<DashboardData> getDashboardSummary(String userId);
  Future<List<SocialActivity>> getRecentSocialActivities(String userId);
  Future<TaskStatistics> getTaskStatistics(String userId);
  Future<TaskStatistics> getDailyTaskStatistics(String userId);
  Future<int> getUnreadNotificationCount(String userId);
  Future<List<WeeklyProgress>> getWeeklyProgress(String userId);
  Future<List<UpcomingTask>> getUpcomingTasks(String userId);
  Future<void> updateTaskStatus(String taskId);
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final SupabaseClient supabase;

  DashboardRemoteDatasourceImpl({required this.supabase});

  @override
  Future<DashboardData> getDashboardSummary(String userId) async {
    try {
      //auto update
      debugPrint('call overdue updata');
      _updateOverdueTasks(userId);
      // DEBUG: Print the ID we are using
      debugPrint('Fetching Dashboard for UserID: $userId');

      // 1. Fetch User Profile
      debugPrint('Step 1: Fetching Profile...');
      final profile = await _getUserProfile(userId);

      // 2. Fetch Stats
      debugPrint('Step 2: Fetching Daily Stats...');
      final daily = await getDailyTaskStatistics(userId);

      debugPrint('Step 3: Fetching Overall Stats...');
      final overall = await getTaskStatistics(userId);

      // 3. Fetch Social
      debugPrint('Step 4: Fetching Activities...');
      final activities = await getRecentSocialActivities(userId);

      debugPrint('Step 5: Fetching Notifications...');
      final notifs = await getUnreadNotificationCount(userId);

      // 4. Fetch Progress
      debugPrint('Step 6: Fetching Weekly Progress...');
      final progress = await getWeeklyProgress(userId);
      // 4. upcoming tasks
      debugPrint('Step 6: Fetching upcoming tasks..');
      final upcoming = await getUpcomingTasks(userId);

      return DashboardData(
        userProfile: profile,
        todayStats: daily,
        overallStats: overall,
        recentActivities: activities,
        unreadNotificationCount: notifs,
        weeklyProgress: progress,
        upcomingTasks: upcoming,
      );
    } catch (e, stacktrace) {
      // THIS PRINT IS CRITICAL TO SEE THE REAL ERROR
      debugPrint('CRITICAL DASHBOARD ERROR: $e');
      debugPrint('Stacktrace: $stacktrace');
      throw ServerFailure(message: e.toString());
    }
  }

  Future<UserProfile> _getUserProfile(String userId) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return UserProfileModel.fromJson(response);
  }

  @override
  Future<TaskStatistics> getDailyTaskStatistics(String userId) async {
    try {
      final now = DateTime.now();
      // Start of day (00:00:00) and End of day (23:59:59)
      final startOfDay = DateTime(
        now.year,
        now.month,
        now.day,
      ).toIso8601String();
      final endOfDay = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
      ).toIso8601String();

      // Fetch tasks for today
      final response = await supabase
          .from('calendar_tasks')
          .select('status')
          .eq('user_id', userId)
          .gte('start_time', startOfDay) // Assuming you filter by due_date
          .lte('end_time', endOfDay);

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
          .from('calendar_tasks')
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
    int overdue = 0;

    for (var task in tasks) {
      final status = task['status'] as String;
      if (status == 'completed') {
        completed++;
      } else if (status == 'overdue') {
        overdue++;
      } else {
        pending++; // 'pending' or 'todo'
      }
    }

    return TaskStatistics(
      total: total,
      completed: completed,
      pending: pending,
      overdue: overdue,
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
    // --- DUMMY DATA MODE ---

    // Simulate network delay to make it feel real
    await Future.delayed(const Duration(milliseconds: 300));

    final List<WeeklyProgress> dummyList = [];
    final now = DateTime.now();

    // Generate data for the last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));

      // Requires: import 'package:intl/intl.dart';
      final dayName = DateFormat('E').format(date);

      // Fake some data logic
      double rate;
      int completed;

      // Make the data look random but realistic
      if (i == 0) {
        // Today
        rate = 0.5; // 50%
        completed = 3;
      } else if (i == 1) {
        // Yesterday
        rate = 0.9;
        completed = 8;
      } else if (i % 2 == 0) {
        rate = 0.2;
        completed = 1;
      } else {
        rate = 0.75;
        completed = 6;
      }

      dummyList.add(
        WeeklyProgress(
          dayName: dayName,
          completionRate: rate,
          tasksCompleted: completed,
        ),
      );
    }

    return dummyList;
  }

  @override
  Future<List<UpcomingTask>> getUpcomingTasks(String userId) async {
    final upcomingResponse = await supabase
        .from('calendar_tasks')
        .select()
        .eq('user_id', userId)
        .eq('status', 'pending')
        .order('end_time', ascending: true)
        .limit(5);
    return (upcomingResponse as List).map((e) {
      return UpcomingTask(
        id: e['id'],
        title: e['title'],
        status: e['status'],
        dueDate: e['end_time'] != null
            ? DateTime.parse(e['end_time']).toLocal()
            : null,
      );
    }).toList();
  }

  Future<void> _updateOverdueTasks(String userId) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final tasksToUpdate = await supabase
          .from('calendar_tasks')
          .select('id')
          .eq('user_id', userId)
          .eq('status', 'pending')
          .lt('end_time', now); // 'lt' means Less Than (Dates before now)

      final List<dynamic> list = tasksToUpdate as List;

      if (list.isEmpty) return; // No overdue tasks found, exit.

      // 2. Extract IDs
      final List<String> ids = list.map((e) => e['id'] as String).toList();

      // 3. Perform Bulk Update
      // "Update status to 'overdue' where ID is in [list of ids]"
      await supabase
          .from('calendar_tasks')
          .update({'status': 'overdue'})
          .inFilter('id', ids)
          .select();

      debugPrint('Auto-updated ${ids.length} tasks to Overdue');
    } catch (e) {
      // We log this, but we DON'T throw an exception.
      // If this fails, we still want to show the dashboard, even if stats are slightly off.
      debugPrint('Error updating overdue tasks: $e');
    }
  }

  @override
  Future<void> updateTaskStatus(String taskId) async {
    try {
      await supabase
          .from('calendar_tasks')
          .update({'status': 'completed'})
          .eq('id', taskId);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  // @override
  // Future<List<WeeklyProgress>> getWeeklyProgress(String userId) async {
  //   try {
  //     final now = DateTime.now();
  //     final sevenDaysAgo = now.subtract(const Duration(days: 7));

  //     // Fetch tasks from last 7 days
  //     final response = await supabase
  //         .from('calendar_tasks')
  //         .select('status, start_date') // Need date to group by day
  //         .eq('user_id', userId)
  //         .gte('end_date', sevenDaysAgo.toIso8601String());

  //     // Process in Dart (Group by Day)
  //     // This map will hold: "Mon" -> {total: 5, completed: 3}
  //     final Map<String, Map<String, int>> weeklyMap = {};

  //     // Initialize last 7 days with 0
  //     for (int i = 6; i >= 0; i--) {
  //       final date = now.subtract(Duration(days: i));
  //       final dayName = DateFormat('E').format(date); // Mon, Tue
  //       weeklyMap[dayName] = {'total': 0, 'completed': 0};
  //     }

  //     for (var task in response) {
  //       final dateStr = task['end_date'];
  //       if (dateStr != null) {
  //         final date = DateTime.parse(dateStr);
  //         final dayName = DateFormat('E').format(date);

  //         if (weeklyMap.containsKey(dayName)) {
  //           weeklyMap[dayName]!['total'] = weeklyMap[dayName]!['total']! + 1;
  //           if (task['status'] == 'completed') {
  //             weeklyMap[dayName]!['completed'] =
  //                 weeklyMap[dayName]!['completed']! + 1;
  //           }
  //         }
  //       }
  //     }

  //     // Convert Map to List<WeeklyProgress>
  //     final List<WeeklyProgress> progressList = [];
  //     weeklyMap.forEach((day, stats) {
  //       double rate = 0.0;
  //       if (stats['total']! > 0) {
  //         rate = stats['completed']! / stats['total']!;
  //       }
  //       progressList.add(
  //         WeeklyProgress(
  //           dayName: day,
  //           completionRate: rate,
  //           tasksCompleted: stats['completed']!,
  //         ),
  //       );
  //     });

  //     return progressList;
  //   } catch (e) {
  //     throw ServerFailure(message: e.toString());
  //   }
  // }
}
