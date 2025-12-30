import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:shell_flow_mobile_app/core/routes/app_routes.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // 1. Initialize with '+'
  final TextEditingController _phoneController = TextEditingController(
    text: '+',
  );

  Country? _selectedCountry;
  bool _syncContacts = true;

  @override
  void initState() {
    super.initState();
    // This name MUST match the function name below
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  // --- LOGIC: Handle Persistent '+' and Auto-Sync Flag ---
  void _onPhoneChanged() {
    final String text = _phoneController.text;

    // A. PREVENT REMOVING '+'
    if (!text.startsWith('+')) {
      _phoneController.value = const TextEditingValue(
        text: '+',
        selection: TextSelection.collapsed(offset: 1),
      );
      return;
    }

    // B. AUTO-SYNC: Typing Code -> Show Flag/Country Name
    final String inputCode = text.replaceFirst('+', '');
    if (inputCode.isNotEmpty) {
      // Look up country in the library
      final matches = countries
          .where((c) => inputCode.startsWith(c.dialCode))
          .toList();

      if (matches.isNotEmpty) {
        // Sort to get specific matches first (e.g. +251 instead of +2)
        matches.sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

        // Only call setState if the country actually changed (prevents loop errors)
        if (_selectedCountry?.dialCode != matches.first.dialCode) {
          setState(() {
            _selectedCountry = matches.first;
          });
        }
      } else {
        if (_selectedCountry != null) setState(() => _selectedCountry = null);
      }
    } else {
      if (_selectedCountry != null) setState(() => _selectedCountry = null);
    }
  }

  // --- LOGIC: Manual Selection -> Fill Phone Field ---
  void _selectCountryManual(Country country) {
    setState(() {
      _selectedCountry = country;
      // We explicitly include the '+' here
      _phoneController.text = '+${country.dialCode}';
      // Move cursor to the end
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF1D2733,
      ), // Dark Telegram-style background
      resizeToAvoidBottomInset: true, // Pushes button up when keyboard opens
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            // SCROLLABLE CONTENT AREA
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Your phone number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Please confirm your country code\nand enter your phone number.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 40),

                    // --- COUNTRY SELECTION BOX ---
                    GestureDetector(
                      onTap: _showCountryPicker,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            if (_selectedCountry != null) ...[
                              Text(
                                _selectedCountry!.flag,
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Text(
                                _selectedCountry?.name ?? 'Country',
                                style: TextStyle(
                                  color: _selectedCountry == null
                                      ? Colors.grey
                                      : Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- PHONE NUMBER INPUT ---
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        letterSpacing: 1.1,
                      ),
                      cursorColor: Colors.blueAccent,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        labelStyle: const TextStyle(color: Colors.blueAccent),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // --- SYNC CONTACTS ---
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.grey),
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Sync Contacts Shell',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        value: _syncContacts,
                        activeColor: Colors.blueAccent,
                        onChanged: (v) => setState(() => _syncContacts = v!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),

                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Continue with Google
                    // --- BLOC CONSUMER FOR GOOGLE SIGN IN ---
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignedInState || state is AuthenticatedState) {
                          // Navigate to your main page (e.g., Calendar)
                          Navigator.pushNamedAndRemoveUntil(
                            context, 
                            AppRoutes.homePageRoutes, // Change this to your home/calendar route
                            (route) => false,
                          );
                        }
                        if (state is AuthErrorState) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                          );
                        }
                      },
                      builder: (context, state) {
                        // If loading, show a spinner instead of the button
                        if (state is AuthLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.blueAccent),
                          );
                        }

                        return OutlinedButton.icon(
                          onPressed: () {
                            // CALL THE BLOC HERE
                            context.read<AuthBloc>().add(SignInWithGoogleEvent());
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                          ),
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          label: const Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'have an account',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.signIn);
                          },
                          child: const Text(
                            'SignIn',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- FIXED BOTTOM BUTTON ---
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () {
                    debugPrint("Final Phone: ${_phoneController.text}");
                  },
                  backgroundColor: const Color(0xFF50A8EB),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D2733),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListView.builder(
        itemCount: countries.length,
        itemBuilder: (_, i) => ListTile(
          leading: Text(
            countries[i].flag,
            style: const TextStyle(fontSize: 24),
          ),
          title: Text(
            countries[i].name,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Text(
            '+${countries[i].dialCode}',
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () => _selectCountryManual(countries[i]),
        ),
      ),
    );
  }
}
