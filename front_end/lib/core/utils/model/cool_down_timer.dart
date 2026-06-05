class CooldownTimer {
  final bool canSend;
  final Duration remaining;

  CooldownTimer({
    required this.canSend,
    required this.remaining,
  });
}
