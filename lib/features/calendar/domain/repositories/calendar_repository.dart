import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';

abstract class CalendarRepository {
  Future<Either<Failure, CalendarTask>> createTask(CalendarTask task);
  Future<Either<Failure, void>> deleteTask(String taskId);
  Future<Either<Failure, CalendarTask>> updateTask(CalendarTask task);
  Future<Either<Failure, void>> toggleTask(String taskId);
  Future<Either<Failure, List<CalendarTask>>> getTaskByRange(DateTime start, DateTime end);
  Future<Either<Failure, List<CalendarTask>>> getAllTask();
  Future<Either<Failure, List<CalendarTask>>> getTaskById(String taskId);
}