import 'package:flutter/material.dart';

class ConquistaNotificationStyle {
  static const Color background = Color(0xFF1E1E2E);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);

  static const double radius = 14;

  static const EdgeInsets padding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  static const Duration animationDuration = Duration(milliseconds: 650);

  static const Duration visibleDuration = Duration(milliseconds: 1800);

  static const TextStyle titleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );
}
