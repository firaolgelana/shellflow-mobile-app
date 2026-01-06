import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum TaskStatus { pending, completed, overdue }

class CalendarTask extends Equatable {
  final String? id; 
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final Color color;
  final TaskStatus status; // 2. Use Enum here

  const CalendarTask({
    this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.color,
    this.status = TaskStatus.pending, // 3. Default value in Dart
  });

  // Helper to allow modification (e.g. checkbox toggle)
  CalendarTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    Color? color,
    TaskStatus? status,
  }) {
    return CalendarTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      color: color ?? this.color,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, title, startTime, endTime, isAllDay, color, status];
}