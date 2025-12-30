import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> singUpUser(User user);
  Future<Either<Failure, User>> singInUser(User user);
  Future<Either<Failure, void>> signOUt();
  Future<Either<Failure, User>> singInWithGoogle();
}
