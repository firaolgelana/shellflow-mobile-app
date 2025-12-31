import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/widgets/email_sign_up.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/widgets/phone_sign_up.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// 1. Add SingleTickerProviderStateMixin for the TabController
class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 2. Initialize the controller here
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF1D2733);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        title: const Text(
          'Create Account',
          style: TextStyle(color: Colors.white),
        ),
        // 3. Put the TabBar in the "bottom" of the AppBar
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Email'),
            Tab(text: 'Phone'),
          ],
        ),
      ),
      // 4. Use TabBarView to show the different pages
      body: TabBarView(
        controller: _tabController,
        children: const [
          EmailSignUp(), // Logic for Email/Name/Password
          PhoneSignUp(), // Your existing Phone logic
        ],
      ),
    );
  }
}
