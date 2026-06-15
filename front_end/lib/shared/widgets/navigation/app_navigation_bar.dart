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
    return Container(
      height: 60, // 🔥 mais compacto
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF121212)
            : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12), // 🔥 mais suave
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(context, Icons.home, 0),
          _buildItem(context, Icons.fastfood, 1),
          _buildItem(context, Icons.add, 2),
          _buildItem(context, Icons.list, 3),
          _buildItem(context, Icons.attach_money, 4),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, int index) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Icon(
            icon,
            size: 24, // 🔥 levemente menor
            color: isSelected
                ? const Color(0xFFD32F2F)
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.grey,          ),
        ),
      ),
    );
  }
}
