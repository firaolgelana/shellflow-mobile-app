import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/pages/sign_in.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: SignIn()
    );
  }
}