class TaskStatistics {
  final int total;
  final int completed;
  final int pending;
  final int overdue;

  TaskStatistics({
    required this.total,
    required this.completed,
    required this.pending,
    required this.overdue,
  });

  TaskStatistics copyWith({
    int? total,
    int? completed,
    int? pending,
    int? overdue,
  }) {
    return TaskStatistics(
      total: total ?? this.total,
      completed: completed ?? this.completed,
      pending: pending ?? this.pending,
      overdue: overdue ?? this.overdue,
    );
  }
}