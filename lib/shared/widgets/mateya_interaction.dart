import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MateyaTapScale extends StatefulWidget {
  const MateyaTapScale({
    super.key,
    required this.child,
    this.borderRadius,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 110),
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final double pressedScale;
  final Duration duration;

  @override
  State<MateyaTapScale> createState() => _MateyaTapScaleState();
}

class _MateyaTapScaleState extends State<MateyaTapScale> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.borderRadius == null
        ? widget.child
        : ClipRRect(borderRadius: widget.borderRadius!, child: widget.child);

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}

class MateyaPressable extends StatelessWidget {
  const MateyaPressable({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.customBorder,
    this.padding,
    this.pressedScale = 0.96,
    this.enableHapticFeedback = true,
    this.splashColor,
    this.highlightColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final EdgeInsetsGeometry? padding;
  final double pressedScale;
  final bool enableHapticFeedback;
  final Color? splashColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final shape =
        customBorder ??
        (borderRadius == null
            ? null
            : RoundedRectangleBorder(borderRadius: borderRadius!));
    final content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    if (onTap == null) {
      return content;
    }

    return MateyaTapScale(
      borderRadius: borderRadius,
      pressedScale: pressedScale,
      child: Material(
        color: Colors.transparent,
        shape: shape,
        clipBehavior: shape == null ? Clip.none : Clip.antiAlias,
        child: InkWell(
          customBorder: customBorder,
          borderRadius: customBorder == null ? borderRadius : null,
          splashColor: splashColor,
          highlightColor: highlightColor,
          onTap: () {
            if (enableHapticFeedback) {
              HapticFeedback.selectionClick();
            }
            onTap?.call();
          },
          child: content,
        ),
      ),
    );
  }
}
