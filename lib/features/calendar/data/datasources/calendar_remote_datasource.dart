import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shell_flow_mobile_app/features/calendar/data/models/calendar_task_model.dart';

abstract class CalendarRemoteDatasource {
  /// Accepts Model, Returns Model
  Future<CalendarTaskModel> createTask(CalendarTaskModel task);
  
  Future<void> deleteTask(String taskId);
  
  Future<CalendarTaskModel> updateTask(CalendarTaskModel task);
  
  Future<CalendarTaskModel> getTaskById(String taskId);
  
  Future<List<CalendarTaskModel>> getAllTasks();
  
  Future<List<CalendarTaskModel>> getTasksByRange(DateTime start, DateTime end);
}

class CalendarRemoteDatasourceImpl implements CalendarRemoteDatasource {
  final SupabaseClient supabase;

  CalendarRemoteDatasourceImpl(this.supabase);

  // Use the new clean table we discussed
  static const _table = 'calendar_tasks';

  @override
  Future<CalendarTaskModel> createTask(CalendarTaskModel task) async {
    // 1. Get current user ID
    final userId = supabase.auth.currentUser!.id;

    // 2. Use the Model's toJson method (pass userId)
    final response = await supabase
        .from(_table)
        .insert(task.toJson(userId: userId))
        .select()
        .single();

    // 3. Return Model
    return CalendarTaskModel.fromJson(response);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await supabase.from(_table).delete().eq('id', taskId);
  }

  @override
  Future<CalendarTaskModel> updateTask(CalendarTaskModel task) async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from(_table)
        .update(task.toJson(userId: userId))
        .eq('id', task.id!) // Ensure ID exists for update
        .select()
        .single();

    return CalendarTaskModel.fromJson(response);
  }

  @override
  Future<CalendarTaskModel> getTaskById(String taskId) async {
    final response = await supabase
        .from(_table)
        .select()
        .eq('id', taskId)
        .single();

    return CalendarTaskModel.fromJson(response);
  }

  @override
  Future<List<CalendarTaskModel>> getAllTasks() async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from(_table)
        .select()
        .eq('user_id', userId)
        .order('start_time'); // Order by actual time

    return (response as List)
        .map((json) => CalendarTaskModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<CalendarTaskModel>> getTasksByRange(
    DateTime start,
    DateTime end,
  ) async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from(_table)
        .select()
        .eq('user_id', userId)
        // Filter where start_time is between start and end
        .gte('start_time', start.toUtc().toIso8601String())
        .lte('start_time', end.toUtc().toIso8601String())
        .order('start_time');

    return (response as List)
        .map((json) => CalendarTaskModel.fromJson(json))
        .toList();
  }
}