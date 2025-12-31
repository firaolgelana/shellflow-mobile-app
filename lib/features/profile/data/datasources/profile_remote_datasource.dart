import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRemoteDatasource {
  Future<UserProfile> getProfile(UserProfile profile);
  Future<UserProfile> updateProfile(UserProfile profile);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource{
  @override
  Future<UserProfile> getProfile(UserProfile profile) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
  
}
