import 'package:flutter/material.dart';

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}