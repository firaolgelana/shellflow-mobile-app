import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/account.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/notifications.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/preference.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/privacy.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/security.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/user_setting.dart';

abstract class SettingRepository {
  Future<Either<Failure, Account>> userAccount();
  Future<Either<Failure, UserSetting>> getUserSetting();
  Future<Either<Failure, Preference>> updatePreference(Preference preference);
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    NotificationSettings settings,
  );
  Future<Either<Failure, Security>> updateSecurity(Security security);
  Future<Either<Failure, Privacy>> updatePrivacy(Privacy privacy);
  Future<Either<Failure, void>> deleteAccount();
}
