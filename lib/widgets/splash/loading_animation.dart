import 'package:flutter/material.dart';
import 'package:masiha_doctor/widgets/splash/loading_dots_painter.dart';

class LoadingAnimation extends StatelessWidget {
  final AnimationController controller;
  const LoadingAnimation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: controller,
      child: SizedBox(
        width: 40,
        height: 40,
        child: CustomPaint(
          painter: LoadingDotsPainter(),
        ),
      ),
    );
  }
}
