import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/weekly_progress.dart';

class WeeklyProgressModel extends WeeklyProgress {
  WeeklyProgressModel({
    required super.dayName,
    required super.completionRate,
    required super.tasksCompleted,
  });
  factory WeeklyProgressModel.fromJson(Map<String, dynamic> json) {
    return WeeklyProgressModel(
      dayName: json['dayName'],
      completionRate: json['completionRate'],
      tasksCompleted: json['tasksCompleted'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'dayName': dayName,
      'completionRate': completionRate,
      'tasksCompleted': tasksCompleted,
    };
  }
}
