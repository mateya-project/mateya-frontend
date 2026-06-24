import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class MateyaWebViewportShell extends StatelessWidget {
  const MateyaWebViewportShell({super.key, required this.child});

  static const double _phoneWidth = 402;
  static const double _desktopInset = 24;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }

    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final canUsePhoneViewport =
            constraints.maxWidth >= _phoneWidth + (_desktopInset * 2);
        if (!canUsePhoneViewport) {
          return child;
        }

        final viewportHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : mediaQuery.size.height;
        final shellMediaQuery = mediaQuery.copyWith(
          size: Size(_phoneWidth, viewportHeight),
        );

        return ColoredBox(
          color: AppColors.webViewportBackdrop,
          child: Center(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 32,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: SizedBox(
                width: _phoneWidth,
                height: viewportHeight,
                child: MediaQuery(
                  data: shellMediaQuery,
                  child: ClipRect(child: child),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
