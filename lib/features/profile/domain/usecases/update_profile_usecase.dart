import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUsecase extends Equatable {
  final ProfileRepository repository;
  const UpdateProfileUsecase({required this.repository});
  Future<Either<Failure, UserProfile>> call(UserProfile userProfile) {
    return repository.updateProfile(userProfile);
  }

  @override
  List<Object?> get props => [];
}
