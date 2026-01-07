import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shell_flow_mobile_app/core/routes/app_routes.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/pages/features_page.dart';
// Import your AuthBloc if you have one for logout
// import 'package:shell_flow_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

Widget drawerWidget(BuildContext context) {
  return Drawer(
    // Wrap the list in BlocBuilder to listen for data changes
    child: BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        // 1. Initialize Default Values (Loading/Error state)
        String displayName = 'Loading...';
        String emailOrPhone = ''; // Or username
        String? avatarUrl;
        String initials = '?';

        // 2. Extract Data if Loaded
        if (state is DashboardLoaded) {
          final profile = state.data.userProfile;

          // Use display name, fallback to username, fallback to 'User'
          displayName = profile.name;

          // Assuming UserProfile has an email field. If not, use username.
          emailOrPhone = profile.email;

          avatarUrl = profile.profilePictureUrl;

          // Calculate initials for fallback
          if (displayName.isNotEmpty) {
            initials = displayName[0].toUpperCase();
          }
        }

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Row(
                children: [
                  // 3. Dynamic Avatar
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: (avatarUrl == null || avatarUrl.isEmpty)
                        ? Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  // 4. Dynamic Text
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          emailOrPhone,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Drawer Items ---
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close Drawer
                Navigator.pushNamed(context, AppRoutes.profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Tasks'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.allTaskPage);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.people,
              ), // 'people' is better for friends
              title: const Text('Friends'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the Social Page we built earlier
                // Navigator.pushNamed(context, AppRoutes.social);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.settingsPage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.featured_play_list),
              title: const Text('Features'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FeaturesPage()),
                );
              },
            ),

            // 5. Logout Logic
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Call your Auth Bloc here to logout
                // context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        );
      },
    ),
  );
}
