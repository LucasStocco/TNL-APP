/*
Ele vai ser o “orquestrador real da UI”:

✔ coloca Header
✔ posiciona Container
✔ resolve animação
✔ controla expansão (home vs telas)
 */

import 'package:flutter/material.dart';
import 'home_header_widget.dart';
import 'home_content_container.dart';

class HomeLayoutWidget extends StatelessWidget {
  final Widget child;
  final bool isHome;

  const HomeLayoutWidget({
    super.key,
    required this.child,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: AppHeaderWidget(
            title: "TáNaLista",
            subtitle: "Organize suas compras no",
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
          top: isHome ? 200 : 0,
          left: 0,
          right: 0,
          bottom: isHome ? 90 : 0,
          child: isHome
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeContentContainer(child: child),
                )
              : Container(
                  color: Colors.white,
                  child: SafeArea(child: child),
                ),
        ),
      ],
    );
  }
}
