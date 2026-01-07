import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/user_setting.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/repositories/setting_repository.dart';

class GetSettingUsecase {
  final SettingRepository repository;
  const GetSettingUsecase({required this.repository});
  Future<Either<Failure, UserSetting>> call(String userId) {
    return repository.getUserSetting(userId);
  }
}
