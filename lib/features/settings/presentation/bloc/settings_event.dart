part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers the initial fetch of all settings
class LoadSettingsEvent extends SettingsEvent {}

/// Updates Theme, Language, etc.
class UpdatePreferenceEvent extends SettingsEvent {
  final Preference preference;
  const UpdatePreferenceEvent(this.preference);
  @override
  List<Object?> get props => [preference];
}

/// Updates Push/Email settings
class UpdateNotificationEvent extends SettingsEvent {
  final NotificationSettings notificationSettings;
  const UpdateNotificationEvent(this.notificationSettings);
  @override
  List<Object?> get props => [notificationSettings];
}

/// Updates Privacy (Public/Private profile)
class UpdatePrivacyEvent extends SettingsEvent {
  final Privacy privacy;
  const UpdatePrivacyEvent(this.privacy);
  @override
  List<Object?> get props => [privacy];
}

/// Updates Security (2FA, Biometrics)
class UpdateSecurityEvent extends SettingsEvent {
  final Security security;
  const UpdateSecurityEvent(this.security);
  @override
  List<Object?> get props => [security];
}

/// Updates Account Info (Phone, Plan)
class UpdateAccountEvent extends SettingsEvent {
  final Account account;
  const UpdateAccountEvent(this.account);
  @override
  List<Object?> get props => [account];
}

/// Deletes the user account permanently
class DeleteAccountEvent extends SettingsEvent {}