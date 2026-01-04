import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class GetTaskComments {
  final SocialRepository repository;
  GetTaskComments({required this.repository});
  Future<Either<Failure, List<SocialComment>>> call(String taskId) {
    return repository.getTaskComments(taskId: taskId);
  }
}
