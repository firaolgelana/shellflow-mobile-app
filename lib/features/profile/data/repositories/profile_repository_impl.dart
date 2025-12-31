import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  @override
  Future<Either<Failure, UserProfile>> getProfile(UserProfile userProfile) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile userProfile) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}