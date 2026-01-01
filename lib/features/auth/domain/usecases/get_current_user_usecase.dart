import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/entities/user.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository;
  const GetCurrentUserUsecase({required this.repository});
  Future<Either<Failure, User>> call() {
    return repository.getCurrentUser();
  }
}
