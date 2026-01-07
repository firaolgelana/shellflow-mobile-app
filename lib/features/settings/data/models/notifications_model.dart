import 'package:shell_flow_mobile_app/features/settings/domain/entities/notifications.dart';

class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({
    required super.pushEnabled,
    required super.emailEnabled,
    required super.taskReminders,
    required super.socialInteractions,
    required super.friendRequests,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      // Maps snake_case (DB) to camelCase (Dart)
      pushEnabled: json['push_enabled'] ?? true,
      emailEnabled: json['email_enabled'] ?? true,
      taskReminders: json['notify_task_reminders'] ?? true,
      socialInteractions: json['notify_social_interactions'] ?? true,
      friendRequests: json['notify_friend_requests'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push_enabled': pushEnabled,
      'email_enabled': emailEnabled,
      'notify_task_reminders': taskReminders,
      'notify_social_interactions': socialInteractions,
      'notify_friend_requests': friendRequests,
    };
  }

  factory NotificationSettingsModel.fromEntity(NotificationSettings entity) {
    return NotificationSettingsModel(
      pushEnabled: entity.pushEnabled,
      emailEnabled: entity.emailEnabled,
      taskReminders: entity.taskReminders,
      socialInteractions: entity.socialInteractions,
      friendRequests: entity.friendRequests,
    );
  }
}