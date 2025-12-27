import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/core/routes/app_routes.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/widgets/app_input_decoration.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obsecurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShellFlow'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Email'),
              TextFormField(
                decoration: appInputDecoration(
                  hint: 'example@gmail.com',
                  prefixIcon: Icons.email,
                ),
              ),
              const Text('Password'),
              TextFormField(
                decoration: appInputDecoration(
                  hint: '*******',
                  prefixIcon: Icons.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obsecurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obsecurePassword = !_obsecurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'password required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      debugPrint('correct form');
                    }
                  },
                  child: const Text('  SignIn  ',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("don't have an account"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signUp);
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
