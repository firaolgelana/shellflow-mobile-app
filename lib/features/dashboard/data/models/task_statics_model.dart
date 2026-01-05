import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/task_statics.dart';

class TaskStaticsModel extends TaskStatistics {
  TaskStaticsModel({
    required super.total,
    required super.completed,
    required super.pending,
    required super.inProgress,
  });
  factory TaskStaticsModel.fromJson(Map<String, dynamic> json) {
    return TaskStaticsModel(
      total: json['total'],
      completed: json['completed'],
      pending: json['pending'],
      inProgress: json['inProgress'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'inProgress': inProgress,
    };
  }
}
