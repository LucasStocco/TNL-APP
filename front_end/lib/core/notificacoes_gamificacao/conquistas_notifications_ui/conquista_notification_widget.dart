import 'package:flutter/material.dart';
import 'conquista_badge_icon.dart';
import 'conquista_notification_style.dart';

class ConquistaNotificationWidget extends StatelessWidget {
  final String titulo;
  final String descricao;

  const ConquistaNotificationWidget({
    super.key,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            constraints: const BoxConstraints(
              maxWidth: 340,
              minWidth: 280,
            ),
            padding: ConquistaNotificationStyle.padding,
            decoration: BoxDecoration(
              color: ConquistaNotificationStyle.background,
              borderRadius: BorderRadius.circular(
                ConquistaNotificationStyle.radius,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ConquistaBadgeIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // 🔥 chave do ajuste
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2), // 👈 leve shift pra esquerda/direita
                        child: Text(
                          titulo,
                          style: ConquistaNotificationStyle.titleStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2), // 👈 mesmo alinhamento
                        child: Text(
                          descricao,
                          style: ConquistaNotificationStyle.descriptionStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
