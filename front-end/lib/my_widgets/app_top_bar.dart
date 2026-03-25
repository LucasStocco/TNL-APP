import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view/user_screen.dart';
import '../view/settings_screen.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: Colors.red,
      title: Text(
        "TáNaLista",
        style: GoogleFonts.delius(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
