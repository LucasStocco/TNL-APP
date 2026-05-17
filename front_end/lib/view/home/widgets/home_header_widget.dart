import 'package:crud_flutter/view/auto_cadastro/user_screen.dart';
import 'package:crud_flutter/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showActions;

  const AppHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      child: Stack(
        children: [
          // 🔴 Fundo
          Container(
            color: const Color(0xFFD32F2F),
          ),

          // 🎨 ÍCONES (decorativos fixos)
          buildIcon(
            top: 10,
            left: -10,
            angle: -0.2,
            size: 85,
            alpha: 0.32,
            asset: 'assets/icons/header_home/icons8-bread-48.png',
          ),

          buildIcon(
            bottom: 10,
            right: -7,
            angle: 0.4,
            size: 70,
            alpha: 0.25,
            asset: 'assets/icons/header_home/icons8-cherry-48.png',
          ),

          buildIcon(
            top: 20,
            right: 10,
            angle: 0.3,
            size: 65,
            alpha: 0.20,
            asset: 'assets/icons/header_home/icons8-american-pancakes-48.png',
          ),

          // 🔥 CONTEÚDO DINÂMICO
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 📝 TEXTO DINÂMICO
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 3),
                      Text(
                        title,
                        style: GoogleFonts.delius(
                          fontSize:
                              40, // 👈 ajustei pra funcionar em todas telas
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.0,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ⚙️ BOTÕES OPCIONAIS
                  if (showActions)
                    Row(
                      children: [
                        _buildCircleButton(Icons.person, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UserScreen()),
                          );
                        }),
                        const SizedBox(width: 10),
                        _buildCircleButton(Icons.settings, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SettingsScreen()),
                          );
                        }),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔧 helper
  Widget buildIcon({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double angle = 0,
    double size = 60,
    double alpha = 0.25,
    required String asset,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: Image.asset(
          asset,
          width: size,
          color: Colors.white.withValues(alpha: alpha),
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFFF44336)),
        onPressed: onTap,
      ),
    );
  }
}
