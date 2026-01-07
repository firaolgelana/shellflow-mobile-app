import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/notifications.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/repositories/setting_repository.dart';

class NotificationUsecase {
  final SettingRepository repository;
  const NotificationUsecase({required this.repository});
  Future<Either<Failure, NotificationSettings>> call(NotificationSettings settings) {
    return repository.updateNotificationSettings(settings);
  }
}
