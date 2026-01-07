import 'package:shell_flow_mobile_app/features/settings/domain/entities/user_setting.dart';
import 'account_model.dart';
import 'preference_model.dart';
import 'privacy_model.dart';
import 'security_model.dart';
import 'notifications_model.dart';

class UserSettingModel extends UserSetting {
  const UserSettingModel({
    required AccountModel super.account,
    required PreferenceModel super.preference,
    required NotificationSettingsModel super.notifications,
    required PrivacyModel super.privacy,
    required SecurityModel super.security,
  });

  // Since UserSetting is an aggregate, we typically construct it manually
  // in the Repository after fetching data from different sources.
  // However, if you wanted to pass a Map containing all data:
  factory UserSettingModel.fromMap({
    required Map<String, dynamic> profileData,
    required Map<String, dynamic> localPrefs,
    required Map<String, dynamic> authData,
  }) {
    return UserSettingModel(
      account: AccountModel.fromJson({...profileData, ...authData}),
      privacy: PrivacyModel.fromJson(profileData),
      notifications: NotificationSettingsModel.fromJson(profileData),
      preference: PreferenceModel.fromJson(localPrefs),
      security: SecurityModel.fromJson({...authData, ...localPrefs}),
    );
  }
}