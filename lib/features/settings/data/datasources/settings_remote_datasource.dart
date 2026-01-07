import 'package:shared_preferences/shared_preferences.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/settings/data/models/notifications_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shell_flow_mobile_app/core/errors/exceptions.dart'; 
import 'package:shell_flow_mobile_app/features/settings/domain/entities/account.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/notifications.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/preference.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/privacy.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/security.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/user_setting.dart';
import 'package:shell_flow_mobile_app/features/settings/data/models/account_model.dart';
import 'package:shell_flow_mobile_app/features/settings/data/models/preference_model.dart';
import 'package:shell_flow_mobile_app/features/settings/data/models/privacy_model.dart';
import 'package:shell_flow_mobile_app/features/settings/data/models/user_setting_model.dart';
abstract class SettingsRemoteDatasource {
  Future<Account> userAccount(String userId);
  Future<UserSetting> getUserSetting(String userId);
  Future<Preference> updatePreference(Preference preference);
  Future<NotificationSettings> updateNotificationSettings(NotificationSettings settings);
  Future<Privacy> updatePrivacy(Privacy privacy);
  Future<Security> updateSecurity(Security security);
  Future<void> deleteAccount();
}
class SettingsRemoteDatasourceImpl implements SettingsRemoteDatasource {
  final SupabaseClient supabase;
  final SharedPreferences sharedPreferences;
  SettingsRemoteDatasourceImpl({
    required this.supabase,
    required this.sharedPreferences,
  });
  String get _currentUserId => supabase.auth.currentUser!.id;
  static const String CACHED_THEME = 'CACHED_THEME';
  static const String CACHED_LANG = 'CACHED_LANG';
  static const String CACHED_24H = 'CACHED_24H';
  static const String CACHED_BIOMETRICS = 'CACHED_BIOMETRICS';
  @override
  Future<UserSetting> getUserSetting(String userId) async {
    try {
      final profileResponse = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      final user = supabase.auth.currentUser;
      if (user == null) throw  const ServerFailure(message: 'User not authenticated');
      final Map<String, dynamic> authData = {
        'email': user.email,
        'phone': user.phone,
        'created_at': user.createdAt, 
        'email_confirmed_at': user.emailConfirmedAt,
        'is_2fa_enabled': user.appMetadata['providers']?.contains('factor') ?? false, 
      };
      final localPrefs = {
        'theme': sharedPreferences.getString(CACHED_THEME),
        'language_code': sharedPreferences.getString(CACHED_LANG),
        'use_24_hour_format': sharedPreferences.getBool(CACHED_24H),
        'biometrics_enabled': sharedPreferences.getBool(CACHED_BIOMETRICS),
      };
      return UserSettingModel.fromMap(
        profileData: profileResponse,
        authData: authData,
        localPrefs: localPrefs,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  @override
  Future<Preference> updatePreference(Preference preference) async {
    try {
      final model = PreferenceModel.fromEntity(preference);
      await sharedPreferences.setString(CACHED_THEME, model.theme.name);
      await sharedPreferences.setString(CACHED_LANG, model.languageCode);
      await sharedPreferences.setBool(CACHED_24H, model.use24HourFormat);
      return preference;
    } catch (e) {
      throw CacheException(); 
    }
  }
  @override
  Future<NotificationSettings> updateNotificationSettings(
      NotificationSettings settings) async {
    try {
      final model = NotificationSettingsModel.fromEntity(settings);
      await supabase
          .from('profiles')
          .update(model.toJson())
          .eq('id', _currentUserId);
      return settings;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  @override
  Future<Privacy> updatePrivacy(Privacy privacy) async {
    try {
      final model = PrivacyModel.fromEntity(privacy);
      await supabase
          .from('profiles')
          .update(model.toJson())
          .eq('id', _currentUserId);
      return privacy;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  @override
  Future<Security> updateSecurity(Security security) async {
    try {
      await sharedPreferences.setBool(
          CACHED_BIOMETRICS, security.biometricsEnabled);
      return security;
    } catch (e) {
      throw CacheException();
    }
  }
  @override
  Future<void> deleteAccount() async {
    try {
      await supabase.rpc('delete_user_account'); 
      await supabase.auth.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  @override
  Future<Account> userAccount(String userId) async {
    try {
      final user = supabase.auth.currentUser;
      final profile = await supabase
          .from('profiles')
          .select('created_at, plan_type') 
          .eq('id', userId)
          .single();
      if (user == null) throw const ServerException(message: "No User");
      return AccountModel.fromJson({
        'email': user.email,
        'phone': user.phone,
        'created_at': user.createdAt,
        'email_confirmed_at': user.emailConfirmedAt,
        'plan_type': profile['plan_type']
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}