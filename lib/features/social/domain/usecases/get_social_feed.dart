import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_task.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class GetSocialFeed {
  final SocialRepository repository;
  GetSocialFeed({required this.repository});
  Future<Either<Failure, List<SocialTask>>> call() {
    return repository.getSocialFeed();
  }
}
