import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color bg = Color(0xFF1D2733);
  static const Color cardBg = Color(0xFF24303F); // Slightly lighter for cards
  static const Color accentBlue = Color(0xFF50A8EB);
  static const Color grey = Colors.grey;
  static const Color orange = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Shells and Achievements
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          title: const Text("Profile", style: TextStyle(color: Colors.white)),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.white))],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is! SignedInState) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = state.user;
            final String displayName = user.name?.isNotEmpty == true ? user.name! : user.email!.split('@').first;
            final String initials = displayName.isNotEmpty ? displayName[0].toUpperCase() : "?";

            return SingleChildScrollView(
              child: Column(
                children: [
                  // 1. HEADER SECTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: accentBlue,
                              child: Text(initials, style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                  const Text("@username_placeholder", style: TextStyle(color: accentBlue)),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Daily builder. Learning Flutter and mastering productivity. 🚀",
                                    style: TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 2. STATS ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat("Followers", "1.2k"),
                            _buildStat("Following", "450"),
                            _buildStat("Streak", "12 🔥", color: orange),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 3. ACTION BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: accentBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                onPressed: () {},
                                child: const Text("Follow", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                onPressed: () {},
                                child: const Text("Message", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. TAB BAR
                  const TabBar(
                    indicatorColor: accentBlue,
                    labelColor: accentBlue,
                    unselectedLabelColor: grey,
                    tabs: [
                      Tab(text: "Public Shells"),
                      Tab(text: "Achievements"),
                    ],
                  ),

                  // 5. CONTENT AREA
                  // Note: In a real app, use a Sized box or NestedScrollView for the TabBarView
                  Container(
                    height: 500, // Fixed height for demo
                    padding: const EdgeInsets.all(16),
                    child: TabBarView(
                      children: [
                        // TAB 1: SHELLS FEED
                        ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildShellCard("Morning Routine", "3/5 Tasks", 0.6, isPinned: true),
                            _buildShellCard("Deep Work: Flutter App", "1/1 Tasks", 1.0),
                            _buildShellCard("Gym: Leg Day", "0/4 Tasks", 0.1),
                          ],
                        ),
                        // TAB 2: ACHIEVEMENTS
                        const Center(child: Text("Badges will appear here", style: TextStyle(color: grey))),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper: Stat Item
  static Widget _buildStat(String label, String value, {Color color = Colors.white}) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: grey, fontSize: 13)),
      ],
    );
  }

  // Helper: Shell Card (Task Progress)
  static Widget _buildShellCard(String title, String progressText, double percent, {bool isPinned = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: isPinned ? Border.all(color: accentBlue.withOpacity(0.5)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              if (isPinned) const Icon(Icons.push_pin, color: accentBlue, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: bg,
                  color: percent == 1.0 ? Colors.greenAccent : accentBlue,
                  minHeight: 6,
                ),
              ),
              const SizedBox(width: 12),
              Text(progressText, style: const TextStyle(color: grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}