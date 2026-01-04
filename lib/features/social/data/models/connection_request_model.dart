import 'package:shell_flow_mobile_app/features/social/domain/entities/connection_request.dart';

class ConnectionRequestModel extends ConnectionRequest {
  ConnectionRequestModel({
    required super.requestId,
    required super.sender,
    required super.sentAt,
  });
  factory ConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    return ConnectionRequestModel(
      requestId: json['requestId'],
      sender: json['sender'],
      sentAt: json['sentAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'requestId': requestId, 'sender': sender, 'sentAt': sentAt};
  }
}
