import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/preference.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/repositories/setting_repository.dart';

class PreferenceUsecase {
  final SettingRepository repository;
  const PreferenceUsecase({required this.repository});
  Future<Either<Failure, Preference>> call(Preference preference) {
    return repository.updatePreference(preference);
  }
}
