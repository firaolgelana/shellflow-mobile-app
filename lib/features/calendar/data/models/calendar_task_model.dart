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
    required super.status,
  });

  factory CalendarTaskModel.fromJson(Map<String, dynamic> json) {
    return CalendarTaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['start_time']).toLocal(),
      endTime: DateTime.parse(json['end_time']).toLocal(),
      isAllDay: json['is_all_day'] ?? false,
      color: Color(json['color_value'] ?? 0xFF0F8644),
      
      // --- THE FIX IS HERE ---
      // We convert the String 'pending' to the Enum TaskStatus.pending
      status: _mapStringToStatus(json['status']), 
    );
  }

  Map<String, dynamic> toJson({required String userId}) {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
      'is_all_day': isAllDay,
      'color_value': color.value,
      
      // Convert Enum back to String for Database
      'status': status.name, 
    };
  }

  factory CalendarTaskModel.fromEntity(CalendarTask task) {
    return CalendarTaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      startTime: task.startTime,
      endTime: task.endTime,
      isAllDay: task.isAllDay,
      color: task.color,
      status: task.status,
    );
  }

  // --- HELPER FUNCTION ---
  static TaskStatus _mapStringToStatus(String? status) {
    // Look through the Enum values to find one that matches the string
    return TaskStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TaskStatus.pending, // Default if not found or null
    );
  }
}