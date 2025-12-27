import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/core/routes/app_routes.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/widgets/app_input_decoration.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Phone Number'),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: appInputDecoration(
                  hint: '+251 9XXXXXXXX',
                  prefixIcon: Icons.phone,
                ),
                validator: (value) => value == null || value.length < 9
                    ? 'Enter a valid phone number'
                    : null,
              ),
              const SizedBox(height: 12),

              const Text('Password'),
              TextFormField(
                obscureText: _obscurePassword,
                decoration: appInputDecoration(
                  hint: '********',
                  prefixIcon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) => value == null || value.length < 8
                    ? 'Password must be at least 8 characters'
                    : null,
              ),

              const SizedBox(height: 20),

              /// Sign Up Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: call SignUpPage use case
                    }
                  },
                  child: const Text('Create Account'),
                ),
              ),

              const SizedBox(height: 20),

              /// Divider
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              /// Continue with Google
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Google sign-in
                  },
                  icon: Image.asset('assets/icons/google.jpg',
                  height: 35,),
                  label: const Text('Continue with Google'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have an account'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signIn);
                    },
                    child: const Text('SignIn'),
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
