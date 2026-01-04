import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class GetPendingRequests {
  final SocialRepository repository;
  GetPendingRequests({required this.repository});
  Future<Either<Failure, List<ConnectionRequest>>> call() {
    return repository.getPendingRequests();
  }
}
