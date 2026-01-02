import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/entities/user.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/repositories/auth_repository.dart';

class SigninUsecase {
  final AuthRepository repository;
  SigninUsecase({required this.repository});
  Future<Either<Failure, User>> call({required String email, required String password}) {
    return repository.signInWithEmailPassword(email: email, password: password);
  }
}
