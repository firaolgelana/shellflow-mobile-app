import 'package:flutter/material.dart';

Widget drawerWidget() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero, // IMPORTANT
      children: const [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue, // different color
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150', // sample photo
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Girl',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+251 9XX XXX XXX',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Drawer items
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
        ),
        ListTile(
          leading: Icon(Icons.task),
          title: Text('Tasks'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        ListTile(
          leading: Icon(Icons.featured_play_list),
          title: Text('Features'),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
        ),
      ],
    ),
  );
}
