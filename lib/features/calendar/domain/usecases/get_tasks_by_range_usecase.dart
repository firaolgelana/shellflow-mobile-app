import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/repositories/calendar_repository.dart';

class GetTasksByRangeUsecase {
  final CalendarRepository repository;
  GetTasksByRangeUsecase({required this.repository});
  Future<Either<Failure, List<CalendarTask>>> call(DateTime start, DateTime end) {
    return repository.getTasksByRange(start, end);
  }
}
