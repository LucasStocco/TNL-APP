import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: ''),
      ],
    );
  }
}
