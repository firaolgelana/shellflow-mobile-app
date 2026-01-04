import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class ToggleLikeTask {
  final SocialRepository repository;
  ToggleLikeTask({required this.repository});
  Future<Either<Failure, void>> call(String taskId) {
    return repository.toggleLikeTask(taskId: taskId);
  }
}
