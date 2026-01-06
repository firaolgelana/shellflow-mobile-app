import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class ToggleTaskStatus {
  final DashboardRepository repository;
  const ToggleTaskStatus({required this.repository});
  Future<Either<Failure, void>> call(String taskId) {
    return repository.updateTaskStatus(taskId);
  }
}
