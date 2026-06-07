import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/conquistas_notifications_ui/conquista_notification_widget.dart';

import 'conquista_ui.dart';
import 'conquista_notification_animator.dart';

class ConquistaNotificationController {
  static final Queue<TipoEventoConquista> _queue = Queue();
  static bool _isShowing = false;

  static void show(
    BuildContext context,
    TipoEventoConquista conquista,
  ) {
    _queue.add(conquista);
    _processQueue(context);
  }

  static void _processQueue(BuildContext context) {
    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('⚙️ [CONQUISTA CONTROLLER]');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📦 fila: ${_queue.length}');
    print('👁 isShowing: $_isShowing');

    if (_isShowing) {
      print('⏭️ Já existe uma conquista sendo exibida');
      return;
    }

    if (_queue.isEmpty) {
      print('⏭️ Fila vazia');
      return;
    }

    final overlay = Overlay.of(
      context,
      rootOverlay: true,
    );

    if (overlay == null) {
      print('❌ Overlay não encontrado');
      return;
    }

    final conquista = _queue.removeFirst();
    _isShowing = true;

    print('🏆 Exibindo conquista: ${conquista.name}');
    print('📦 Restante na fila: ${_queue.length}');

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return ConquistaNotificationAnimator(
          onFinish: () {
            print('🏁 Notificação finalizada');
            print('🏆 ${conquista.name}');

            entry.remove();
            _isShowing = false;

            print('🔄 Processando próxima conquista...');
            _processQueue(context);
          },
          child: ConquistaNotificationWidget(
            titulo: conquista.titulo,
            descricao: conquista.descricao,
          ),
        );
      },
    );

    // 🔊 TOCA O SOM DA CONQUISTA
    print('🔊 Tocando áudio da conquista...');

    final player = AudioPlayer();

    player.play(
      AssetSource('sounds/conquista.mp3'),
    );

    // 🚀 EXIBE A NOTIFICAÇÃO
    print('🚀 Inserindo OverlayEntry');

    overlay.insert(entry);

    print('✅ Notificação exibida');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
