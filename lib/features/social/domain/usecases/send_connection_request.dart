import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class SendConnectionRequest {
  final SocialRepository repository;
  SendConnectionRequest({required this.repository});
  Future<Either<Failure, ConnectionRequest>> call(String targetUserId) {
    return repository.sendConnectionRequest(targetUserId: targetUserId);
  }
}
