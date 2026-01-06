import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/upcoming_task.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_daily_task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_recent_social_activities.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_unread_notification_count.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_weekly_progress_usecase.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/toggle_task_status.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/upcoming_tasks.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummary getDashboardSummary;

  final GetUnreadNotificationCount getUnreadNotificationCount;
  final GetDailyTaskStatics getDailyTaskStatistics;
  final GetTaskStatics getTaskStatistics;
  final GetRecentSocialActivities getRecentSocialActivities;
  final GetWeeklyProgressUsecase getWeeklyProgress;
  final UpcomingTasks getUpcomingTasks;
  final ToggleTaskStatus toggleTaskStatus;

  DashboardBloc({
    required this.getDashboardSummary,
    required this.getUnreadNotificationCount,
    required this.getDailyTaskStatistics,
    required this.getTaskStatistics,
    required this.getRecentSocialActivities,
    required this.getWeeklyProgress,
    required this.getUpcomingTasks,
    required this.toggleTaskStatus,
  }) : super(DashboardInitial()) {
    on<FetchDashboardData>(_onFetchDashboardData);
    on<RefreshNotificationCount>(_onRefreshNotificationCount);
    on<RefreshTaskStats>(_onRefreshTaskStats);
    on<ToggleTaskStatusEvent>(_onToggleTaskStatus);
  }

  /// Handles the initial full load of the screen
  Future<void> _onFetchDashboardData(
    FetchDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    // Call the master use case that aggregates everything
    // Assuming GetDashboardSummaryParams takes a userId
    final result = await getDashboardSummary(event.userId);

    result.fold(
      (failure) => emit(DashboardFailure(failure.message)),
      (dashboardData) => emit(DashboardLoaded(dashboardData)),
    );
  }

  /// Example: Optimizes performance by only fetching the notification int
  /// instead of reloading the whole dashboard.
  Future<void> _onRefreshNotificationCount(
    RefreshNotificationCount event,
    Emitter<DashboardState> emit,
  ) async {
    // We can only refresh if we are already loaded
    if (state is DashboardLoaded) {
      final currentData = (state as DashboardLoaded).data;

      final result = await getUnreadNotificationCount(event.userId);

      result.fold(
        (failure) {
          // Ideally, don't emit a full failure state for a background refresh.
          // Just ignore or show a small snackbar message via a Listener.
          // For now, we keep the current state.
        },
        (newCount) {
          final updatedData = DashboardData(
            userProfile: currentData.userProfile,
            todayStats: currentData.todayStats,
            overallStats: currentData.overallStats,
            recentActivities: currentData.recentActivities,
            weeklyProgress: currentData.weeklyProgress,
            unreadNotificationCount: newCount, // <--- UPDATE THIS
            upcomingTasks: currentData.upcomingTasks,
          );

          emit(DashboardLoaded(updatedData));
        },
      );
    }
  }

  /// Example: Refresh just task stats after a user marks a task complete
  Future<void> _onRefreshTaskStats(
    RefreshTaskStats event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentData = (state as DashboardLoaded).data;

      // You might run these in parallel
      final dailyResult = await getDailyTaskStatistics(event.userId);
      final overallResult = await getTaskStatistics(event.userId);

      // Check if both succeeded (this is a simplified check)
      if (dailyResult.isRight() && overallResult.isRight()) {
        final newDaily = dailyResult.getOrElse(() => currentData.todayStats);
        final newOverall = overallResult.getOrElse(
          () => currentData.overallStats,
        );

        final updatedData = DashboardData(
          userProfile: currentData.userProfile,
          todayStats: newDaily, // <--- UPDATED
          overallStats: newOverall, // <--- UPDATED
          recentActivities: currentData.recentActivities,
          weeklyProgress: currentData.weeklyProgress,
          unreadNotificationCount: currentData.unreadNotificationCount,
          upcomingTasks: currentData.upcomingTasks,
        );

        emit(DashboardLoaded(updatedData));
      }
    }
  }

Future<void> _onToggleTaskStatus(
    ToggleTaskStatusEvent event,
    Emitter<DashboardState> emit,
  ) async {
    // 1. Check if we have data currently
    if (state is DashboardLoaded) {
      final currentData = (state as DashboardLoaded).data;
      
      // ---------------------------------------------------------
      // OPTIMISTIC UPDATE: Modify data locally without fetching
      // ---------------------------------------------------------

      // A. Update the List
      // If we are checking it (making it completed), usually we REMOVE it from "Upcoming".
      // If you want to keep it but strike-through, you need to find and replace it.
      // Let's assume we remove it for simplicity (or update status):
      
      final updatedUpcomingList = currentData.upcomingTasks.map((task) {
        if (task.id == event.taskId) {
           // Return a copy with new status (assuming your entity has copyWith)
           // Or if you want to remove it, see filtering logic below.
           return UpcomingTask(
             id: task.id, 
             title: task.title, 
             status: 'completed', // Manually set status
             dueDate: task.dueDate
           );
        }
        return task;
      }).toList();

      // B. Update the Statistics (The Math)
      // If we marked as completed: Pending goes down, Completed goes up.
      final oldStats = currentData.todayStats;
      final newStats = oldStats.copyWith(
        pending: oldStats.pending > 0 ? oldStats.pending - 1 : 0,
        completed: oldStats.completed + 1,
      );

      // C. Create the new Master Data object
      final optimisticData = currentData.copyWith(
        upcomingTasks: updatedUpcomingList,
        todayStats: newStats,
        // You can update overallStats here too if you want
      );

      // D. EMIT IMMEDIATELY
      // The UI updates instantly. No loading spinner. No delay.
      emit(DashboardLoaded(optimisticData));

      // ---------------------------------------------------------
      // BACKGROUND: Sync with Server
      // ---------------------------------------------------------
      
      final result = await toggleTaskStatus(event.taskId);

      result.fold(
        (failure) {
          // If server fails, we must REVERT the changes.
          // In this case, we simply reload the original correct data from server.
          // This happens rarely.
           emit(const DashboardFailure("Failed to sync. Reloading..."));
           add(FetchDashboardData(currentData.userProfile.id));
        },
        (success) {
          // Success! Do nothing. The UI is already correct.
          // debugPrint("Task updated on server successfully.");
        },
      );
    }
  }
}
