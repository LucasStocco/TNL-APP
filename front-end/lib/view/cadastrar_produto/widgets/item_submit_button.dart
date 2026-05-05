import 'package:flutter/material.dart';

class ItemSubmitButton extends StatelessWidget {
  final bool loading;
  final String text;
  final VoidCallback onPressed;

  const ItemSubmitButton({
    super.key,
    required this.loading,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: onPressed,
            child: Text(text),
          );
  }
}
