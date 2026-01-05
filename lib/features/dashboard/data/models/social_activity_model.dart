import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/social_activity.dart';

class SocialActivityModel extends SocialActivity {
  SocialActivityModel({
    required super.id,
    required super.description,
    required super.timestamp,
    required super.type,
  });
  factory SocialActivityModel.fromJson(Map<String, dynamic> json) {
    return SocialActivityModel(
      id: json['id'],
      description: json['description'],
      timestamp: json['timestamp'],
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'timestamp': timestamp,
      'type': type,
    };
  }
}
