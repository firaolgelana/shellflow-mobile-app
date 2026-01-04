import 'dart:ui';
import '../../domain/entities/calendar_task.dart';

class CalendarTaskModel extends CalendarTask {
  const CalendarTaskModel({
    super.id,
    required super.title,
    required super.description,
    required super.startTime,
    required super.endTime,
    required super.isAllDay,
    required super.color,
  });

  // FROM Supabase JSON
  factory CalendarTaskModel.fromJson(Map<String, dynamic> json) {
    return CalendarTaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['start_time']).toLocal(),
      endTime: DateTime.parse(json['end_time']).toLocal(),
      isAllDay: json['is_all_day'] ?? false,
      // Restore Color from Int, default to Green if null
      color: Color(json['color_value'] ?? 0xFF0F8644), 
    );
  }

  // TO Supabase JSON
  Map<String, dynamic> toJson({required String userId}) {
    return {
      if (id != null) 'id': id,
      'user_id': userId, // Required by Supabase
      'title': title,
      'description': description,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
      'is_all_day': isAllDay,
      'color_value': color.value, // Save Color as Int
    };
  }

  // Helper to convert Domain Entity -> Data Model
  factory CalendarTaskModel.fromEntity(CalendarTask task) {
    return CalendarTaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      startTime: task.startTime,
      endTime: task.endTime,
      isAllDay: task.isAllDay,
      color: task.color,
    );
  }
}