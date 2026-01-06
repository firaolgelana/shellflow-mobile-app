// features/dashboard/domain/entities/upcoming_task.dart
import 'package:equatable/equatable.dart';

class UpcomingTask extends Equatable {
  final String id; 
  final String title;
  final String status; 
  final DateTime? dueDate;

  const UpcomingTask({
    required this.id,
    required this.title,
    required this.status,
    this.dueDate,
  });

  @override
  List<Object?> get props => [id, title, status, dueDate];
  
}