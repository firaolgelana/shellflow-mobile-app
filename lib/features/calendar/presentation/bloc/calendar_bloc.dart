import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/create_task_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/delete_task_usecase.dart';
// Note: Assuming GetAllTasksUsecase exists in your project structure
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/get_all_tasks_usecase.dart'; 
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/get_tasks_by_range_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/update_task_usecase.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CreateTaskUsecase createTask;
  final GetAllTasksUsecase getAllTasks; // Renamed to plural for clarity
  final GetTasksByRangeUsecase getTasksByRange;
  final DeleteTaskUsecase deleteTask;
  final UpdateTaskUsecase updateTask;

  // 1. Keep track of the current view (Month/Week)
  DateTime? _currentStart;
  DateTime? _currentEnd;

  CalendarBloc({
    required this.createTask,
    required this.getAllTasks,
    required this.getTasksByRange,
    required this.deleteTask,
    required this.updateTask,
  }) : super(CalendarInitial()) {
    on<LoadAllTasksEvent>(_onLoadAllTasks);
    on<LoadTasksByRangeEvent>(_onLoadTasksByRange);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadAllTasks(
    LoadAllTasksEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());

    // Reset range tracking since we are loading everything
    _currentStart = null;
    _currentEnd = null;

    // Use NoParams() if your usecase requires it, or just call()
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

    // 2. Save the range so we can refresh it later
    _currentStart = event.start;
    _currentEnd = event.end;

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
    // Optional: Emit loading if you want a spinner during save
    // emit(CalendarLoading()); 

    final result = await createTask(event.task);

    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (success) {
        // 3. Smart Refresh: Only reload the current view
        _reloadCurrentView();
      },
    );
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<CalendarState> emit,
  ) async {
    // emit(CalendarLoading());

    final result = await updateTask(event.task);

    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (success) {
        _reloadCurrentView();
      },
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<CalendarState> emit,
  ) async {
    // emit(CalendarLoading());

    final result = await deleteTask(event.taskId);

    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (success) {
        _reloadCurrentView();
      },
    );
  }

  /// Helper to reload data based on what the user was looking at
  void _reloadCurrentView() {
    if (_currentStart != null && _currentEnd != null) {
      add(LoadTasksByRangeEvent(_currentStart!, _currentEnd!));
    } else {
      add(LoadAllTasksEvent());
    }
  }
}