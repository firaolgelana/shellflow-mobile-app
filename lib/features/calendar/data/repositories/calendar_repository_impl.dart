import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/core/network/network_info.dart';
import 'package:shell_flow_mobile_app/features/calendar/data/datasources/calendar_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/calendar/data/models/calendar_task_model.dart'; // Import Model
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  CalendarRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CalendarTask>> createTask(CalendarTask task) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      // CONVERSION: Entity -> Model
      final taskModel = CalendarTaskModel.fromEntity(task);
      
      final result = await remoteDatasource.createTask(taskModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CalendarTask>> updateTask(CalendarTask task) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      // CONVERSION: Entity -> Model
      final taskModel = CalendarTaskModel.fromEntity(task);
      
      final updated = await remoteDatasource.updateTask(taskModel);
      return Right(updated);
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

  // --- IMPLEMENTED MISSING METHODS ---

  @override
  Future<Either<Failure, List<CalendarTask>>> getTasksByRange(
      DateTime startDate, DateTime endDate) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      final result = await remoteDatasource.getTasksByRange(startDate, endDate);
      // Since CalendarTaskModel extends CalendarTask, we can return the list directly.
      // Or use .map((e) => e as CalendarTask).toList() if types act strictly.
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CalendarTask>> getTaskById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      final result = await remoteDatasource.getTaskById(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CalendarTask>>> getAllTasks() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }

    try {
      final result = await remoteDatasource.getAllTasks();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}