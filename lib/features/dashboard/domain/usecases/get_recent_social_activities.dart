import 'package:dartz/dartz.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/social_activity.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetRecentSocialActivities {
  final DashboardRepository repository;
  GetRecentSocialActivities({required this.repository});
  Future<Either<Failure, List<SocialActivity>>> call(String id) {
    return repository.getRecentSocialActivities(id);
  }
}
