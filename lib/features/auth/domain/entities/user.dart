import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final bool isEmailVerified; 

  const User({this.email, this.id, this.password, this.name, this.isEmailVerified = false});
  
  @override
  List<Object?> get props => [];
}
