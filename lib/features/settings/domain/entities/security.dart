import 'package:equatable/equatable.dart';

class Security extends Equatable {
  final bool isTwoFactorEnabled;
  final DateTime? lastPasswordChange;
  final bool biometricsEnabled; // FaceID / Fingerprint for local app lock

  const Security({
    required this.isTwoFactorEnabled,
    this.lastPasswordChange,
    required this.biometricsEnabled,
  });

  factory Security.defaults() {
    return const Security(
      isTwoFactorEnabled: false,
      biometricsEnabled: false,
      lastPasswordChange: null,
    );
  }

  Security copyWith({
    bool? isTwoFactorEnabled,
    DateTime? lastPasswordChange,
    bool? biometricsEnabled,
  }) {
    return Security(
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }

  @override
  List<Object?> get props => [isTwoFactorEnabled, lastPasswordChange, biometricsEnabled];
}