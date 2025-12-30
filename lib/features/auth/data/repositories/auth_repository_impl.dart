import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/core/network/network_info.dart';
import 'package:shell_flow_mobile_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/entities/user.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, void>> signOUt() {
    // TODO: implement signOUt
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> singInUser(User user) {
    // TODO: implement singInUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> singUpUser(User user) {
    // TODO: implement singUpUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> singInWithGoogle() async {
    final isConnected = networkInfo.isConnected;
    if (await isConnected) {
      try {
        final data = remoteDatasource.signInWithGoogle();
        return Right(await data);
      } catch (e) {
        throw Left(Exception(e.toString()));
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
