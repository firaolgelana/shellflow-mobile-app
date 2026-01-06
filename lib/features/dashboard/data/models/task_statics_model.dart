import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/task_statics.dart';

class TaskStaticsModel extends TaskStatistics {
  TaskStaticsModel({
    required super.total,
    required super.completed,
    required super.pending,
    required super.overdue,
  });
  factory TaskStaticsModel.fromJson(Map<String, dynamic> json) {
    return TaskStaticsModel(
      total: json['total'],
      completed: json['completed'],
      pending: json['pending'],
      overdue: json['overdue'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'overdue': overdue,
    };
  }
}
