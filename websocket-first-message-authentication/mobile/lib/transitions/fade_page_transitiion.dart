import 'package:flutter/material.dart';

final class FadePageTransition extends PageRouteBuilder {
  final Widget child;
  final bool isIos;
  final PageTransitionsBuilder matchingBuilder;

  FadePageTransition({
    required this.child,
    this.isIos = false,
    this.matchingBuilder = const CupertinoPageTransitionsBuilder(),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return child;
          },
          maintainState: true,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fade = FadeTransition(
        opacity: animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeInOut),
          ),
        ),
        child: child);
    if (isIos) {
      return matchingBuilder.buildTransitions(
        this,
        context,
        animation,
        secondaryAnimation,
        fade,
      );
    }
    return fade;
  }
}
