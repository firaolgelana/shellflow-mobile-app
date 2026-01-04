import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/core/routes/app_routes.dart';

Widget drawerWidget(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero, // IMPORTANT
      children: [
        const DrawerHeader(
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
                      'Person X',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+251 9XX XXX XXX',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Drawer items
       ListTile(
          leading: const Icon(Icons.person), title: const Text('Profile'),
            onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.profile);
          }),
        ListTile(leading: const Icon(Icons.task), title: const Text('Tasks'),
          onTap: (){

          },
        ),
        ListTile(leading: const Icon(Icons.person), title: const Text('Friends'),
          onTap: (){

          },
        ),
        const ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
        const ListTile(
          leading: Icon(Icons.featured_play_list),
          title: Text('Features'),

        ),
        const ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
      ],
    ),
  );
}
