import 'package:flutter/material.dart';
NavigationBar navBarWidget({
  required int selectedIndex,
  required ValueChanged<int> onSelected,
}) {
  return NavigationBar(
    selectedIndex: selectedIndex,
    onDestinationSelected: onSelected,
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.person),
        label: 'User',
      ),
      NavigationDestination(
        icon: Icon(Icons.chat),
        label: 'Chat',
      ),
      NavigationDestination(
        icon: Icon(Icons.calendar_month_outlined),
        label: 'Calendar',
      ),
    ],
  );
}
