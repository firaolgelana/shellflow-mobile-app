import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/create_task_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/delete_task_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/get_all_task_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/get_task_by_range_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/toggle_task_completion_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/update_task_usecase.dart';
part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CreateTaskUsecase createTask;
  final GetAllTaskUsecase getAllTasks;
  final GetTaskByRangeUsecase getTasksByRange;
  final ToggleTaskCompletionUsecase toggleTask;
  final DeleteTaskUsecase deleteTask;
  final UpdateTaskUsecase updateTask;

  CalendarBloc({
    required this.createTask,
    required this.getAllTasks,
    required this.getTasksByRange,
    required this.toggleTask,
    required this.deleteTask,
    required this.updateTask,
  }) : super(CalendarInitial()) {
    on<LoadAllTasksEvent>(_onLoadAllTasks);
    on<LoadTasksByRangeEvent>(_onLoadTasksByRange);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskEvent>(_onToggleTask);
  }

  Future<void> _onLoadAllTasks(
    LoadAllTasksEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());

    final result = await getAllTasks();

    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (tasks) => emit(CalendarLoaded(tasks)),
    );
  }

  Future<void> _onLoadTasksByRange(
    LoadTasksByRangeEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());

    final result = await getTasksByRange(event.start, event.end);

    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (tasks) => emit(CalendarLoaded(tasks)),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());

    final result = await createTask(event.task);

    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (_) => add(LoadAllTasksEvent()),
    );
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());

    final result = await updateTask(event.task);

    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (_) => add(LoadAllTasksEvent()),
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());

    final result = await deleteTask(event.taskId);

    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (_) => add(LoadAllTasksEvent()),
    );
  }

  Future<void> _onToggleTask(
    ToggleTaskEvent event,
    Emitter<CalendarState> emit,
  ) async {
    final result = await toggleTask(event.taskId);

    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (_) => add(LoadAllTasksEvent()),
    );
  }
}
