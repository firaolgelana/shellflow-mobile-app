import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shell_flow_mobile_app/features/calendar/data/models/calendar_task_model.dart';

abstract class CalendarRemoteDatasource {
  Future<CalendarTask> createTask(CalendarTask task);
  Future<void> deleteTask(String taskId);
  Future<CalendarTask> updateTask(CalendarTask task);
  Future<CalendarTask> getTaskById(String taskId);
  Future<List<CalendarTask>> getAllTasks();
  Future<List<CalendarTask>> getTasksByRange(DateTime start, DateTime end);
}


class CalendarRemoteDatasourceImpl implements CalendarRemoteDatasource {
  final SupabaseClient supabase;

  CalendarRemoteDatasourceImpl(this.supabase);

  static const _table = 'tasks';

  @override
  Future<CalendarTask> createTask(CalendarTask task) async {
    final response = await supabase
        .from(_table)
        .insert(_toJson(task))
        .select()
        .single();

    return CalendarTaskModel.fromJson(response);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await supabase.from(_table).delete().eq('id', taskId);
  }

  @override
  Future<CalendarTask> updateTask(CalendarTask task) async {
    final response = await supabase
        .from(_table)
        .update(_toJson(task))
        .eq('id', task.id)
        .select()
        .single();

    return CalendarTaskModel.fromJson(response);
  }

  @override
  Future<CalendarTask> getTaskById(String taskId) async {
    final response = await supabase
        .from(_table)
        .select()
        .eq('id', taskId)
        .single();

    return CalendarTaskModel.fromJson(response);
  }

  @override
  Future<List<CalendarTask>> getAllTasks() async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from(_table)
        .select()
        .eq('user_id', userId)
        .order('date');

    return response
        .map<CalendarTask>((json) => CalendarTaskModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<CalendarTask>> getTasksByRange(
    DateTime start,
    DateTime end,
  ) async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from(_table)
        .select()
        .eq('user_id', userId)
        .gte('date', start.toIso8601String())
        .lte('date', end.toIso8601String())
        .order('date');

    return response
        .map<CalendarTask>((json) => CalendarTaskModel.fromJson(json))
        .toList();
  }

  Map<String, dynamic> _toJson(CalendarTask task) {
    return {
      'id': task.id,
      'user_id': supabase.auth.currentUser!.id,
      'title': task.title,
      'description': task.description,
      'date': task.startTime.toIso8601String().split('T').first,
      'start_time': task.startTime.toIso8601String(),
      'duration':
          task.endTime.difference(task.startTime).inMinutes,
      'status': task.isCompleted ? 'completed' : 'pending',
      'category': 'work',
    };
  }
}
