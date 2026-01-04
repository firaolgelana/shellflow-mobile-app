import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_task.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class GetSharedTaskDetails {
  final SocialRepository repository;
  GetSharedTaskDetails({required this.repository});
  Future<Either<Failure, SocialTask>> call(String taskId) {
    return repository.getSharedTaskDetails(taskId: taskId);
  }
}
