import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:shell_flow_mobile_app/core/routes/app_routes.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

class OtpPage extends StatelessWidget {
  final String email;
  const OtpPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF1D2733),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignedInState || state is AuthenticatedState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homePageRoutes,
              (route) => false,
            );
          }

          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Verify Email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Code sent to $email",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // ================= OTP INPUT (8 digits) =================
                Pinput(
                  length: 8, // ✅ Supabase OTP length
                  controller: otpController,
                  defaultPinTheme: PinTheme(
                    width: 45,
                    height: 55,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ================= VERIFY BUTTON =================
                state is AuthLoadingState
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                VerifyOtpEvent(
                                  email: email,
                                  otp: otpController.text.trim(),
                                ),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text("Verify & Continue"),
                      ),

                const SizedBox(height: 15),

                // ================= RESEND OTP =================
                TextButton(
                  onPressed: () {
                    // Supabase resends OTP automatically via signup
                    context.read<AuthBloc>().add(
                          SignUpEvent(
                            email: email,
                            password: '', // password ignored by Supabase resend
                            name: '',
                          ),
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification code resent"),
                      ),
                    );
                  },
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
