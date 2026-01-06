part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

/// The main event to load the screen.
/// [userId] is passed here (or you could get it from a user session singleton)
class FetchDashboardData extends DashboardEvent {
  final String userId;
  const FetchDashboardData(this.userId);

  @override
  List<Object> get props => [userId];
}

/// Optional: If you only want to refresh the notification count (e.g., via a timer)
class RefreshNotificationCount extends DashboardEvent {
  final String userId;
  const RefreshNotificationCount(this.userId);
}

/// Optional: If a user completes a task, refresh just the stats
class RefreshTaskStats extends DashboardEvent {
  final String userId;
  const RefreshTaskStats(this.userId);
}
class ToggleTaskStatusEvent extends DashboardEvent {
  final String taskId;
  const ToggleTaskStatusEvent({required this.taskId});
}