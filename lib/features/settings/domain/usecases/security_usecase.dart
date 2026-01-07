import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/security.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/repositories/setting_repository.dart';

class SecurityUsecase {
  final SettingRepository repository;
  const SecurityUsecase({required this.repository});
  Future<Either<Failure, Security>> call(Security security) {
    return repository.updateSecurity(security);
  }
}
