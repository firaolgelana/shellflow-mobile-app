import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDailyTaskStatics {
  final DashboardRepository repository;
  GetDailyTaskStatics({required this.repository});
  Future<Either<Failure, TaskStatistics>> call(String id) {
    return repository.getDailyTaskStatistics(id);
  }
}
