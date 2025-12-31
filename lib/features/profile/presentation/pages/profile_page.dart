import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors based on your image
    const Color scaffoldBg = Color(0xFF1D2733);
    const Color headerBg = Color(0xFF1D2733);
    const Color accentBlue = Color(0xFF50A8EB);
    const Color infoGrey = Colors.grey;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // 1. Profile Header
                  SliverAppBar(
                    expandedHeight: 250,
                    pinned: true,
                    backgroundColor: headerBg,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {},
                    ),
                    actions: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.white), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.orange.shade400,
                            child: const Text(
                              "F",
                              style: TextStyle(fontSize: 40, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Firaol",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "online",
                            style: TextStyle(color: infoGrey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Info Section
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text("Info", style: TextStyle(color: accentBlue, fontWeight: FontWeight.bold)),
                        ),
                        _buildInfoTile("+251 952441687", "Mobile"),
                        _buildInfoTile("@firagelana", "Username", trailing: const Icon(Icons.qr_code_2, color: accentBlue)),
                        const Divider(color: Colors.black26, height: 1),
                      ],
                    ),
                  ),

                  // 3. Persistent TabBar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      const TabBar(
                        indicatorColor: accentBlue,
                        indicatorWeight: 3,
                        labelColor: accentBlue,
                        unselectedLabelColor: infoGrey,
                        tabs: [
                          Tab(text: "Posts"),
                          Tab(text: "Archived Posts"),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: const TabBarView(
                children: [
                  _EmptyStateView(message: "No posts yet..."),
                  _EmptyStateView(message: "No archived posts..."),
                ],
              ),
            ),
          ),

          // 4. Fixed Bottom Button
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
              label: const Text("Add a post"),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String subtitle, {Widget? trailing}) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 17)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      trailing: trailing,
    );
  }
}

// Helper for the Sticky TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF1D2733),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

// Helper for the Empty Content
class _EmptyStateView extends StatelessWidget {
  final String message;
  const _EmptyStateView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Publish photos and videos to display on your profile page",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
          const SizedBox(height: 80), // Space for bottom button
        ],
      ),
    );
  }
}