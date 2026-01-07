import 'package:shell_flow_mobile_app/features/settings/domain/entities/privacy.dart';

class PrivacyModel extends Privacy {
  const PrivacyModel({
    required super.isProfilePrivate,
    required super.defaultTaskVisibility,
    required super.allowTagging,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyModel(
      isProfilePrivate: json['is_profile_private'] ?? false,
      allowTagging: json['allow_tagging'] ?? true,
      defaultTaskVisibility: _mapStringToVisibility(json['default_task_visibility']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_profile_private': isProfilePrivate,
      'allow_tagging': allowTagging,
      'default_task_visibility': _visibilityToString(defaultTaskVisibility),
    };
  }

  factory PrivacyModel.fromEntity(Privacy entity) {
    return PrivacyModel(
      isProfilePrivate: entity.isProfilePrivate,
      defaultTaskVisibility: entity.defaultTaskVisibility,
      allowTagging: entity.allowTagging,
    );
  }

  // --- Helpers for Enum Mapping ---

  static TaskVisibility _mapStringToVisibility(String? val) {
    switch (val) {
      case 'private': return TaskVisibility.private;
      case 'friends_only': return TaskVisibility.friendsOnly;
      default: return TaskVisibility.public;
    }
  }

  static String _visibilityToString(TaskVisibility val) {
    switch (val) {
      case TaskVisibility.private: return 'private';
      case TaskVisibility.friendsOnly: return 'friends_only';
      case TaskVisibility.public: return 'public';
    }
  }
}