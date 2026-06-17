import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class MateyaSkeleton extends StatefulWidget {
  const MateyaSkeleton({
    super.key,
    required this.child,
    this.baseColor = AppColors.disabledSurface,
    this.highlightColor = Colors.white,
    this.period = const Duration(milliseconds: 1400),
  });

  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;

  @override
  State<MateyaSkeleton> createState() => _MateyaSkeletonState();
}

class _MateyaSkeletonState extends State<MateyaSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final width = math.max(bounds.width, 1.0).toDouble();
            final height = math.max(bounds.height, 1.0).toDouble();
            final slide = _controller.value * 2.4 - 1.2;
            return LinearGradient(
              begin: Alignment(-1.8 + slide, -0.2),
              end: Alignment(0.2 + slide, 0.2),
              colors: <Color>[
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const <double>[0.15, 0.32, 0.48],
            ).createShader(Rect.fromLTWH(0, 0, width, height));
          },
          child: child,
        );
      },
    );
  }
}

class MateyaSkeletonBlock extends StatelessWidget {
  const MateyaSkeletonBlock({
    super.key,
    required this.height,
    this.width,
    this.radius = 16,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class MateyaMapSkeleton extends StatelessWidget {
  const MateyaMapSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white.withValues(alpha: 0.88),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: MateyaSkeleton(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: MateyaSkeletonBlock(width: 88, height: 18, radius: 9),
                ),
                SizedBox(height: 24),
                MateyaSkeletonBlock(height: 120, radius: 24),
                SizedBox(height: 18),
                MateyaSkeletonBlock(width: 164, height: 18, radius: 9),
                SizedBox(height: 10),
                MateyaSkeletonBlock(width: 212, height: 14, radius: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
