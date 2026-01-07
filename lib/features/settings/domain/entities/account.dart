import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String email;
  final String? phoneNumber;
  final DateTime joinedAt;
  final bool isVerified;
  // e.g., 'Free', 'Pro', 'Premium'
  final String planType; 

  const Account({
    required this.email,
    this.phoneNumber,
    required this.joinedAt,
    required this.isVerified,
    required this.planType,
  });

  // No copyWith for Email/JoinedAt usually, as those change via specific processes
  // But useful for planType updates
  Account copyWith({
    String? phoneNumber,
    bool? isVerified,
    String? planType,
  }) {
    return Account(
      email: this.email, // Email usually requires a full re-auth flow to change
      phoneNumber: phoneNumber ?? this.phoneNumber,
      joinedAt: this.joinedAt,
      isVerified: isVerified ?? this.isVerified,
      planType: planType ?? this.planType,
    );
  }

  @override
  List<Object?> get props => [email, phoneNumber, joinedAt, isVerified, planType];
}