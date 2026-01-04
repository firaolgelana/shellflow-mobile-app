import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class DeleteComment {
  final SocialRepository repository;
  DeleteComment({required this.repository});
  Future<Either<Failure, void>> call(String commentId) {
    return repository.deleteComment(commentId: commentId);
  }
}
