import 'package:flutter/material.dart';

class NavigationPanel extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const NavigationPanel({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  NavigationPanelState createState() => NavigationPanelState();
}

class NavigationPanelState extends State<NavigationPanel> {
  @override
  Widget build(BuildContext context) {
    final selectedItemColor = Colors.amber[800];
    final unselectedItemColor = Colors.grey;
    final backgroundColor = Colors.blueGrey;

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Medical Adherence',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Caregiver',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      backgroundColor: backgroundColor,
      onTap: widget.onItemTapped,
    );
  }
}
