// sorteio/rotação
import 'dart:math';

class MessageRandomizer {
  static final Random _random = Random();

  static (String, String) pick(
    List<(String, String)> messages,
  ) {
    return messages[_random.nextInt(messages.length)];
  }
}
