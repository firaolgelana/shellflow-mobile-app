import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/repositories/calendar_repository.dart';

class DeleteTaskUsecase {
  final CalendarRepository repository;
  DeleteTaskUsecase({required this.repository});
  Future<Either<Failure, void>> call(String taskId) {
    return repository.deleteTask(taskId);
  }
}
