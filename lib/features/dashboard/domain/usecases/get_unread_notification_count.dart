import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetUnreadNotificationCount {
  final DashboardRepository repository;
  GetUnreadNotificationCount({required this.repository});
  Future<Either<Failure, int>> call(String id) {
    return repository.getUnreadNotificationCount(id);
  }
}
