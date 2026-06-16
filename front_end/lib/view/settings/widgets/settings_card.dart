import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final List<Widget> children;

  /// novo: controla padding interno
  final EdgeInsetsGeometry padding;

  /// novo: controla espaçamento entre itens
  final double spacing;

  const SettingsCard({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.spacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    if (spacing == 0) return children;

    return children
        .expand((child) => [
              child,
              SizedBox(height: spacing),
            ])
        .toList()
      ..removeLast();
  }
}
