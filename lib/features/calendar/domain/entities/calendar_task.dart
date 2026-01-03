import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CalendarTask extends Equatable {
  final String? id; // Null for new tasks
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final Color color;

  const CalendarTask({
    this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.color,
  });

  @override
  List<Object?> get props => [id, title, startTime, endTime, isAllDay, color];
}