class NotificationDecision {
  final bool shouldNotify;

  final String title;

  final String body;

  const NotificationDecision({
    required this.shouldNotify,
    required this.title,
    required this.body,
  });
}
/*
Engine final (pensa, decide, mas não executa):

não envia nada
não conhece NotificationService

Ele só responde:

“o que deve acontecer”
 */
