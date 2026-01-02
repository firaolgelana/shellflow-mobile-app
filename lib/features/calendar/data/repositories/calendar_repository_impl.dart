import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository{
  @override
  Future<Either<Failure, CalendarTask>> createTask(CalendarTask task) {
    // TODO: implement createTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<CalendarTask>>> getAllTask() {
    // TODO: implement getAllTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<CalendarTask>>> getTaskByRange(CalendarTask task) {
    // TODO: implement getTaskByRange
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> toggleTask(String taskId) {
    // TODO: implement toggleTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CalendarTask>> updateTask(CalendarTask task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}