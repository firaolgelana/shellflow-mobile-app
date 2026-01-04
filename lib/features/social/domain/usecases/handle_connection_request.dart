import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

class HandleConnectionRequest {
  final SocialRepository repository;
  HandleConnectionRequest({required this.repository});
  Future<Either<Failure, void>> call(
    String requestId,
    ConnectionRequestAction action,
  ) {
    return repository.handleConnectionRequest(
      requestId: requestId,
      action: action,
    );
  }
}
