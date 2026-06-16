import 'package:audioplayers/audioplayers.dart';

class AudioConquistaService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> tocarConquista() async {
    try {
      await _player.play(
        AssetSource('sounds/conquista.mp3'),
      );

      print('🔊 SOM DE CONQUISTA TOCADO');
    } catch (e) {
      print('❌ ERRO AO TOCAR SOM DA CONQUISTA');
      print(e);
    }
  }
}
