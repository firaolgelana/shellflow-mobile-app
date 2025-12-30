import 'package:shell_flow_mobile_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({super.email, super.id, super.name, super.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id, 'email': email, 'password': password};
  }
}
