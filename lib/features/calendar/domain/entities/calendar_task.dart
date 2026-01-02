import 'package:equatable/equatable.dart';

class CalendarTask extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String creatorId; // Link to the Auth User ID
  final List<String> participantIds; // Social aspect: IDs of invited friends
  final String color; // Hex code for the "pills" (e.g., #50A8EB)
  final bool isCompleted;

  const CalendarTask({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.creatorId,
    this.participantIds = const [],
    this.color = '#50A8EB',
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, title, startTime, endTime, creatorId, participantIds, isCompleted];
}