import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/upcoming_task.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class UpcomingTasks {
  final DashboardRepository repository;
  const UpcomingTasks({required this.repository});
  Future<Either<Failure, List<UpcomingTask>>> call(String userId) {
    return repository.getUpComingTasks(userId);
  }
}
