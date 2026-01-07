import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/account.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/repositories/setting_repository.dart';

class AccountUsecase {
  final SettingRepository repository;
  const AccountUsecase({required this.repository});
  Future<Either<Failure, Account>> call(String userId) {
    return repository.userAccount(userId);
  }
}
