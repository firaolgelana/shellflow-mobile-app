import 'package:equatable/equatable.dart';

import 'account.dart';
import 'notifications.dart';
import 'preference.dart';
import 'privacy.dart';
import 'security.dart';

class UserSetting extends Equatable {
  final Account account;
  final Preference preference;
  final NotificationSettings notifications;
  final Privacy privacy;
  final Security security;

  const UserSetting({
    required this.account,
    required this.preference,
    required this.notifications,
    required this.privacy,
    required this.security,
  });

  /// Helper to create a copy when a nested setting changes
  UserSetting copyWith({
    Account? account,
    Preference? preference,
    NotificationSettings? notifications,
    Privacy? privacy,
    Security? security,
  }) {
    return UserSetting(
      account: account ?? this.account,
      preference: preference ?? this.preference,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      security: security ?? this.security,
    );
  }

  @override
  List<Object?> get props => [account, preference, notifications, privacy, security];
}