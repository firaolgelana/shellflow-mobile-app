import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sign Up', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
      ),
      body: Padding(padding: EdgeInsets.all(10),
      child: Form(child: Column(children: [
        
      ],)),),
    );
  }
}