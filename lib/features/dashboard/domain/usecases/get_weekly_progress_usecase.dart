import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/weekly_progress.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetWeeklyProgressUsecase {
  final DashboardRepository repository;
  GetWeeklyProgressUsecase({required this.repository});
  Future<Either<Failure, List<WeeklyProgress>>> call(String id) {
    return repository.getWeeklyProgress(id);
  }
}
