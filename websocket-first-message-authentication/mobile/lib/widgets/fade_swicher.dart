import 'package:flutter/material.dart';

class FadeSwitcher extends StatelessWidget {
  const FadeSwitcher({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation.drive(
            Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        );
      },
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeIn,
      child: child,
    );
  }
}
