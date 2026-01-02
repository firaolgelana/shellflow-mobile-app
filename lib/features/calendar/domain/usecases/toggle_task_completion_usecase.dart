import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/repositories/calendar_repository.dart';

class ToggleTaskCompletionUsecase {
  final CalendarRepository repository;
  ToggleTaskCompletionUsecase({required this.repository});
  Future<Either<Failure, void>> call(String taskId) {
    return repository.toggleTask(taskId);
  }
}
