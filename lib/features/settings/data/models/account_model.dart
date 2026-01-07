import 'package:shell_flow_mobile_app/features/settings/domain/entities/account.dart';

class AccountModel extends Account {
  const AccountModel({
    required super.email,
    super.phoneNumber,
    required super.joinedAt,
    required super.isVerified,
    required super.planType,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? json['phone_number'],
      joinedAt: DateTime.parse(json['created_at']), // Supabase standard field
      isVerified: json['email_confirmed_at'] != null, // Logic for verification
      planType: json['plan_type'] ?? 'Free',
    );
  }
}