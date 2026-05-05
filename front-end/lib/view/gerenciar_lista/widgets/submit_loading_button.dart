import 'package:flutter/material.dart';

class SubmitLoadingButton extends StatelessWidget {
  final bool loading;
  final String text;
  final VoidCallback onPressed;

  const SubmitLoadingButton({
    super.key,
    required this.loading,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const CircularProgressIndicator();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}