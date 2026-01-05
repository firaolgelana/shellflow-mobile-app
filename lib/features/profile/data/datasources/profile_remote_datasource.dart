import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/profile/data/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRemoteDatasource {
  /// Fetches profile data using the ID inside the [profile] object.
  Future<UserProfile> getProfile(UserProfile profile);
  Future<UserProfile> updateProfile(UserProfile profile);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final SupabaseClient supabase;

  ProfileRemoteDatasourceImpl({required this.supabase});

  @override
  Future<UserProfile> getProfile(UserProfile profile) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', profile.id)
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    try {
      // Map domain entity fields to Database columns (snake_case)
      final updates = {
        'username': profile.username,
        'display_name': profile.name,
        'bio': profile.bio,
        'photo_url': profile.profilePictureUrl, 
        'updated_at': DateTime.now().toIso8601String(), 
      };

      final response = await supabase
          .from('profiles')
          .update(updates)
          .eq('id', profile.id)
          .select() 
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}