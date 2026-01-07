import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/privacy.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/repositories/setting_repository.dart';

class PrivacyUsecase {
  final SettingRepository repository;
  const PrivacyUsecase({required this.repository});
  Future<Either<Failure, Privacy>> call(Privacy privacy) {
    return repository.updatePrivacy(privacy);
  }
}
