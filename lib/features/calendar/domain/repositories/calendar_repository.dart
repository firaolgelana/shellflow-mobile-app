import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';

abstract class CalendarRepository {
  Future<Either<Failure, CalendarTask>> createTask(CalendarTask task);
  Future<Either<Failure, void>> deleteTask(String taskId);
  Future<Either<Failure, CalendarTask>> updateTask(CalendarTask task);
  Future<Either<Failure, CalendarTask>> toggleTask(CalendarTask task);
  Future<Either<Failure, CalendarTask>> getTaskByRange(CalendarTask task);
  Future<Either<Failure, CalendarTask>> getAllTask();
}