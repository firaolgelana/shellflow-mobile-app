import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  const User({this.email, this.id, this.password, this.name});
  
  @override
  List<Object?> get props => [];
}
