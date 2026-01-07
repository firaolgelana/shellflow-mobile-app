import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/core/network/network_info.dart';
import 'package:shell_flow_mobile_app/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/account.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/notifications.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/preference.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/privacy.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/security.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/user_setting.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/repositories/setting_repository.dart';

class SettingsRepositoryImpl implements SettingRepository {
  final NetworkInfo networkInfo;
  final SettingsRemoteDatasource remoteDatasource;
  SettingsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDatasource,
  });
  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.deleteAccount();
        return Right(result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserSetting>> getUserSetting(String userId)async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getUserSetting(userId);
        return Right(result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    NotificationSettings settings,
  )async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.updateNotificationSettings(settings);
        return Right(result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Preference>> updatePreference(Preference preference)async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.updatePreference(preference);
        return Right(result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Privacy>> updatePrivacy(Privacy privacy)async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.updatePrivacy(privacy);
        return Right(result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Security>> updateSecurity(Security security)async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.updateSecurity(security);
        return Right(result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Account>> userAccount(String userId)async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.userAccount(userId);
        return Right(result);
      } catch (e) {
        return left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
