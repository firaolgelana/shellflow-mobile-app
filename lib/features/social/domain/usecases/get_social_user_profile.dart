import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class GetSocialUserProfile {
  final SocialRepository repository;
  GetSocialUserProfile({required this.repository});
  Future<Either<Failure, UserProfile>> call(String userId) {
    return repository.getSocialUserProfile(userId: userId);
  }
}
