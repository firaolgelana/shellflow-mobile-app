class WeeklyProgress {
  final String dayName; // "Mon", "Tue"
  final double completionRate; // 0.0 to 1.0
  final int tasksCompleted;

  WeeklyProgress({
    required this.dayName,
    required this.completionRate,
    required this.tasksCompleted,
  });
}