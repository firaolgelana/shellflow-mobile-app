import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class SearchUsers {
  final SocialRepository repository;
  SearchUsers({required this.repository});
  Future<Either<Failure, List<SocialUser>>> call(String query) {
    return repository.searchUsers(query: query);
  }
}
