// domain/entities/connection_request.dart
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';

class ConnectionRequest {
  final String requestId;
  final SocialUser sender; // The user asking to connect
  final DateTime sentAt;
  final String? message; // "Hey, let's collaborate on tasks!"

  const ConnectionRequest({
    required this.requestId,
    required this.sender,
    required this.sentAt,
    this.message,
  });
}