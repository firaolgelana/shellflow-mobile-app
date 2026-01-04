import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';

class Meeting {
  Meeting({
    this.id, // Nullable for new tasks, String (UUID) for existing
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    this.description = '',
    required this.isAllDay,
  });

  /// ID is String? because Supabase uses UUID strings. 
  /// It is null when creating a new task that hasn't been saved yet.
  String? id; 
  String eventName;
  String description;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  // ---------------------------------------------------------------------------
  // 1. CONVERT DOMAIN ENTITY -> UI MODEL
  // Used when reading data from Bloc/Repository to show in SfCalendar
  // ---------------------------------------------------------------------------
  factory Meeting.fromEntity(CalendarTask task) {
    return Meeting(
      id: task.id,
      eventName: task.title,
      description: task.description,
      from: task.startTime,
      to: task.endTime,
      background: task.color,
      isAllDay: task.isAllDay,
    );
  }

  // ---------------------------------------------------------------------------
  // 2. CONVERT UI MODEL -> DOMAIN ENTITY
  // Used when saving/updating data from the UI to send to Bloc
  // ---------------------------------------------------------------------------
  CalendarTask toEntity() {
    return CalendarTask(
      id: id,
      title: eventName,
      description: description,
      startTime: from,
      endTime: to,
      isAllDay: isAllDay,
      color: background,
    );
  }
}