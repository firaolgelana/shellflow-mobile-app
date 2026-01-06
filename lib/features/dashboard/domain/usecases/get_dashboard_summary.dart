import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardSummary {
  final DashboardRepository repository;
  GetDashboardSummary({required this.repository});
  Future<Either<Failure, DashboardData>> call(String id) {
    return repository.getDashboardSummary(id);
  }
}
