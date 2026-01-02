import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';

class CalendarTaskModel extends CalendarTask {
  const CalendarTaskModel({
    required super.id,
    required super.title,
    super.description,
    required super.startTime,
    required super.endTime,
    required super.creatorId,
    super.participantIds,
    super.color,
    super.isCompleted,
  });

  /// From JSON (API / Supabase)
  factory CalendarTaskModel.fromJson(Map<String, dynamic> json) {
    return CalendarTaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      creatorId: json['creator_id'] as String,
      participantIds: List<String>.from(json['participant_ids'] ?? []),
      color: json['color'] ?? '#50A8EB',
      isCompleted: json['is_completed'] ?? false,
    );
  }

  /// To JSON (API / Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'creator_id': creatorId,
      'participant_ids': participantIds,
      'color': color,
      'is_completed': isCompleted,
    };
  }

  /// Useful for updates (toggle completion, edit task, etc.)
  CalendarTaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? creatorId,
    List<String>? participantIds,
    String? color,
    bool? isCompleted,
  }) {
    return CalendarTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      creatorId: creatorId ?? this.creatorId,
      participantIds: participantIds ?? this.participantIds,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
