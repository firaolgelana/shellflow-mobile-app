import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/repositories/calendar_repository.dart';

class UpdateTaskUsecase {
  final CalendarRepository repository;
  UpdateTaskUsecase({required this.repository});
  Future<Either<Failure, CalendarTask>> call(CalendarTask task) {
    return repository.updateTask(task);
  }
}
