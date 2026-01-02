part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllTasksEvent extends CalendarEvent {}

class LoadTasksByRangeEvent extends CalendarEvent {
  final DateTime start;
  final DateTime end;

  const LoadTasksByRangeEvent(this.start, this.end);

  @override
  List<Object?> get props => [start, end];
}

class CreateTaskEvent extends CalendarEvent {
  final CalendarTask task;

  const CreateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends CalendarEvent {
  final CalendarTask task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends CalendarEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskEvent extends CalendarEvent {
  final String taskId;

  const ToggleTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
