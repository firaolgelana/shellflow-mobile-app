import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class AddComment {
  final SocialRepository repository;
  AddComment({required this.repository});
  Future<Either<Failure, SocialComment>> call(String taskId, String content) {
    return repository.addComment(taskId: taskId, content: content);
  }
}
