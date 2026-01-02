import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/core/network/network_info.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:shell_flow_mobile_app/features/calendar/data/datasources/calendar_remote_datasource.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  CalendarRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CalendarTask>> createTask(
      CalendarTask task) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      final result = await remoteDatasource.createTask(task);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      await remoteDatasource.deleteTask(taskId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CalendarTask>>> getAllTask() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      final tasks = await remoteDatasource.getAllTasks();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CalendarTask>>> getTaskByRange(
    DateTime start,
    DateTime end,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      final tasks =
          await remoteDatasource.getTasksByRange(start, end);
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CalendarTask>> updateTask(
      CalendarTask task) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      final updated =
          await remoteDatasource.updateTask(task);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CalendarTask>>> getTaskById(
      String taskId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      final task =
          await remoteDatasource.getTaskById(taskId);
      return Right([task]);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleTask(String taskId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      final task =
          await remoteDatasource.getTaskById(taskId);

      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
      );

      await remoteDatasource.updateTask(updatedTask);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
