import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordRegex =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  InputDecoration appInputDecoration({
    required String label,
    double radius = 10,
    String? hint,
    IconData? prefixIcon,
    Widget? suffixIcon,
    Color? color,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(width: 1, color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShellFlow'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: appInputDecoration(
                  label: 'email',
                  hint: 'example@gmail.com',
                  prefixIcon: Icons.email,
                ),
              ),
              TextFormField(
                decoration: appInputDecoration(
                  label: 'password',
                  hint: '*******',
                  prefixIcon: Icons.password,
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.visibility),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'password required';
                  }
                  if (!passwordRegex.hasMatch(value)) {
                    return 'Password must be at least 8 characters, include upper, lower, number and special character';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    debugPrint('correct form');
                  }
                },
                child: Text('Sigin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
