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

  // ================= SIGN UP =================
  @override
  Future<Either<Failure, User>> singUpUser(User user) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.signUpUser(user);
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  // ================= SIGN IN =================
  @override
  Future<Either<Failure, User>> singInUser(User user) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.signInUser(user);
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  // ================= GOOGLE SIGN IN =================
  @override
  Future<Either<Failure, User>> singInWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.signInWithGoogle();
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  // ================= PHONE SIGN IN =================
  @override
  Future<Either<Failure, User>> singInWithPhone() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.signInWithPhone();
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  // ================= SIGN OUT =================
  @override
  Future<Either<Failure, void>> signOUt() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.signOut();
        return const Right(null);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOTP(String email, String token) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.verifyOTP(
          email: email,
          token: token,
        );
        return Right(result);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet connection'));
    }
  }
}
