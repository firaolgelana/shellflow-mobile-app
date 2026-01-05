import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/core/network/network_info.dart';
import 'package:shell_flow_mobile_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  ProfileRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, UserProfile>> getProfile(
    UserProfile userProfile,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = remoteDatasource.getProfile(userProfile);
        return Right(await result);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    UserProfile userProfile,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = remoteDatasource.updateProfile(userProfile);
        return Right(await result);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
