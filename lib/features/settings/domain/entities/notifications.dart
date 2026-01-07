import 'package:equatable/equatable.dart';

class NotificationSettings extends Equatable {
  // Master Switches
  final bool pushEnabled;
  final bool emailEnabled;

  // Granular Controls
  final bool taskReminders;    // "You have a task due in 1 hour"
  final bool socialInteractions; // "John liked your task"
  final bool friendRequests;     // "Sarah sent you a request"

  const NotificationSettings({
    required this.pushEnabled,
    required this.emailEnabled,
    required this.taskReminders,
    required this.socialInteractions,
    required this.friendRequests,
  });

  factory NotificationSettings.defaults() {
    return const NotificationSettings(
      pushEnabled: true,
      emailEnabled: true,
      taskReminders: true,
      socialInteractions: true,
      friendRequests: true,
    );
  }

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? taskReminders,
    bool? socialInteractions,
    bool? friendRequests,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      taskReminders: taskReminders ?? this.taskReminders,
      socialInteractions: socialInteractions ?? this.socialInteractions,
      friendRequests: friendRequests ?? this.friendRequests,
    );
  }

  @override
  List<Object?> get props => [
        pushEnabled,
        emailEnabled,
        taskReminders,
        socialInteractions,
        friendRequests,
      ];
}