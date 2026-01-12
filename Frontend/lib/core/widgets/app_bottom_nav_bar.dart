import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
    );
  }
}
