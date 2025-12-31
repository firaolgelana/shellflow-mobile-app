import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/repositories/auth_repository.dart';

class SignoutUsecase {
  final AuthRepository repository;
  const SignoutUsecase({required this.repository});
  Future<Either<Failure, void>> call() {
    return repository.signOUt();
  }
}
