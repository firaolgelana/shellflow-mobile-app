import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';

class GetProfileUsecase extends Equatable {
  final ProfileRepository repository;
  const GetProfileUsecase({required this.repository});
  Future<Either<Failure, UserProfile>> call(UserProfile userProfile) {
    return repository.getProfile(userProfile);
  }

  @override
  List<Object?> get props => [];
}
