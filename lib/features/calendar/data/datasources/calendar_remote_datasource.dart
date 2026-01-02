import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';

abstract class CalendarRemoteDatasource {
  Future<CalendarTask> createTask(CalendarTask task);
  Future<CalendarTask> deleteTask(CalendarTask task);
  Future<CalendarTask> updateTask(CalendarTask task);
  Future<CalendarTask> getTaskByRange(CalendarTask task);
  Future<CalendarTask> getAllTask();
  Future<CalendarTask> getTaskById();

}

class CalendarRemoteDatasourceImpl implements CalendarRemoteDatasource{
  @override
  Future<CalendarTask> createTask(CalendarTask task) {
    // TODO: implement createTask
    throw UnimplementedError();
  }

  @override
  Future<CalendarTask> deleteTask(CalendarTask task) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<CalendarTask> getAllTask() {
    // TODO: implement getAllTask
    throw UnimplementedError();
  }

  @override
  Future<CalendarTask> getTaskById() {
    // TODO: implement getTaskById
    throw UnimplementedError();
  }

  @override
  Future<CalendarTask> getTaskByRange(CalendarTask task) {
    // TODO: implement getTaskByRange
    throw UnimplementedError();
  }

  @override
  Future<CalendarTask> updateTask(CalendarTask task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
  
}