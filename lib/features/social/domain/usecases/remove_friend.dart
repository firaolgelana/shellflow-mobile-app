import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class RemoveFriend {
  final SocialRepository repository;
  RemoveFriend({required this.repository});
  Future<Either<Failure, void>> call(String friendId) {
    return repository.removeFriend(friendId: friendId);
  }
}
