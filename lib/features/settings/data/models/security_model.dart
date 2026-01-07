import 'package:shell_flow_mobile_app/features/settings/domain/entities/security.dart';

class SecurityModel extends Security {
  const SecurityModel({
    required super.isTwoFactorEnabled,
    super.lastPasswordChange,
    required super.biometricsEnabled,
  });

  factory SecurityModel.fromJson(Map<String, dynamic> json) {
    return SecurityModel(
      isTwoFactorEnabled: json['is_2fa_enabled'] ?? false,
      biometricsEnabled: json['biometrics_enabled'] ?? false, // Stored locally usually
      lastPasswordChange: json['last_password_change'] != null
          ? DateTime.parse(json['last_password_change'])
          : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'is_2fa_enabled': isTwoFactorEnabled,
      'biometrics_enabled': biometricsEnabled,
      'last_password_change': lastPasswordChange?.toIso8601String(),
    };
  }
}