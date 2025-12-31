import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shell_flow_mobile_app/core/constants/app_colors.dart';
import 'package:shell_flow_mobile_app/core/routes/app_routes.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/widgets/custom_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF1D2733);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: darkBg,
        elevation: 0,
        title: const Center(
          child: Text('SignIn', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // Email Field
              CustomTextField(
                // controller: _emailController,
                label: "Email Address",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email";
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              const SizedBox(height: 15),

              // Password Field with Eye Icon
              CustomTextField(
                // controller: _passwordController,
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
                obscureText: _obscurePassword,
                validator: (value) => value!.length < 6
                    ? "Password must be at least 6 chars"
                    : null,
                toggleVisibility: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // 4. Trigger Validation
                  if (formKey.currentState!.validate()) {
                    debugPrint('comfirm');
                    Navigator.pushNamed(context, AppRoutes.homePageRoutes);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueshade,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "SignIn",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white12)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.white12)),
                ],
              ),
              const SizedBox(height: 20),

              // GOOGLE BUTTON
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.white12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                  size: 20,
                ),
                label: const Text(
                  "Continue with Google",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "don't have an account",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signUp);
                    },
                    child: const Text(
                      'SignUp',
                      style: TextStyle(color: Colors.blue),
                    ),
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
