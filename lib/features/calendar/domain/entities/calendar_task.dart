import 'package:equatable/equatable.dart';

class CalendarTask extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String creatorId;
  final List<String> participantIds;
  final String color;
  final String status;
  final bool isCompleted;
  final String category;

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
    this.status = 'pending',
    this.category = 'work'
  });
  CalendarTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? creatorId,
    List<String>? participantIds,
    String? color,
    bool? isCompleted,
    String? category,
    String? status,
  }) {
    return CalendarTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      creatorId: creatorId ?? this.creatorId,
      participantIds: participantIds ?? this.participantIds,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      status:  status ?? this.status
    );
  }
  @override
  List<Object?> get props => [
    id,
    title,
    startTime,
    endTime,
    creatorId,
    participantIds,
    isCompleted,
    status,
    category
  ];
}
