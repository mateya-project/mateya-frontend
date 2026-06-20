import 'package:flutter/material.dart';

class MateyaFadeSlideSwitcher extends StatelessWidget {
  const MateyaFadeSlideSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 220),
    this.beginOffset = const Offset(0.04, 0),
    this.layoutBuilder,
  });

  final Widget child;
  final Duration duration;
  final Offset beginOffset;
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
      transitionBuilder: (child, animation) {
        return buildMateyaFadeSlideTransition(
          child,
          animation,
          beginOffset: beginOffset,
        );
      },
      child: child,
    );
  }
}

Widget buildMateyaFadeSlideTransition(
  Widget child,
  Animation<double> animation, {
  Offset beginOffset = const Offset(0.04, 0),
}) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  return FadeTransition(
    opacity: curvedAnimation,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: child,
    ),
  );
}
