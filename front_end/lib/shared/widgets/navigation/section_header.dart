import 'package:crud_flutter/view/categorias/Animated_layout_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onToggleLayout;
  final bool isGrid;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onToggleLayout,
    required this.isGrid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TEXTO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.delius(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // BOTÃO DE LAYOUT E ANIMAÇÃOr
          if (onToggleLayout != null)
            AnimatedLayoutToggleButton(
              onPressed: onToggleLayout!,
              isGrid: isGrid,
            ),
        ],
      ),
    );
  }
}
