import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

enum MateyaHeaderVariant { noBackArrow, backArrow, chatDetail }

class MateyaHeader extends StatelessWidget {
  const MateyaHeader.noBackArrow({super.key, this.onLanguageTap})
    : variant = MateyaHeaderVariant.noBackArrow,
      onBack = null,
      title = null,
      subtitle = null;

  const MateyaHeader.backArrow({super.key, this.onBack, this.onLanguageTap})
    : variant = MateyaHeaderVariant.backArrow,
      title = null,
      subtitle = null;

  const MateyaHeader.chatDetail({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
    this.onLanguageTap,
  }) : variant = MateyaHeaderVariant.chatDetail;

  final MateyaHeaderVariant variant;
  final VoidCallback? onBack;
  final VoidCallback? onLanguageTap;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final bool showsBackButton = variant != MateyaHeaderVariant.noBackArrow;

    return SizedBox(
      height: AppSpacing.headerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (showsBackButton)
            Positioned(
              left: 8,
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 30,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          if (variant == MateyaHeaderVariant.chatDetail)
            _ChatDetailTitle(title: title!, subtitle: subtitle!)
          else
            const _MateyaWordmark(fontSize: 24),
          Positioned(
            right: 12,
            child: IconButton(
              onPressed: onLanguageTap,
              icon: Icon(
                Icons.language_rounded,
                size: 28,
                color: onLanguageTap == null
                    ? AppColors.textSecondary
                    : const Color(0xFF43464D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatDetailTitle extends StatelessWidget {
  const _ChatDetailTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 72),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class MateyaLogoMark extends StatelessWidget {
  const MateyaLogoMark({super.key, this.size = 168});

  final double size;

  @override
  Widget build(BuildContext context) {
    final strokeWidth = size * 0.18;

    return SizedBox(
      width: size,
      height: size * 0.9,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: size * 0.12,
            bottom: 0,
            child: Container(
              width: strokeWidth,
              height: size * 0.75,
              decoration: BoxDecoration(
                color: const Color(0xFF171A22),
                borderRadius: BorderRadius.circular(size * 0.08),
              ),
            ),
          ),
          Positioned(
            left: size * 0.22,
            bottom: size * 0.18,
            child: Transform.rotate(
              angle: -0.58,
              child: Container(
                width: size * 0.18,
                height: size * 0.58,
                decoration: BoxDecoration(
                  color: const Color(0xFF171A22),
                  borderRadius: BorderRadius.circular(size * 0.08),
                ),
              ),
            ),
          ),
          Positioned(
            right: size * 0.14,
            bottom: 0,
            child: Container(
              width: strokeWidth,
              height: size * 0.78,
              decoration: BoxDecoration(
                color: const Color(0xFF49D64E),
                borderRadius: BorderRadius.circular(size * 0.08),
              ),
            ),
          ),
          Positioned(
            right: size * 0.24,
            bottom: size * 0.19,
            child: Transform.rotate(
              angle: 0.72,
              child: Container(
                width: size * 0.18,
                height: size * 0.56,
                decoration: BoxDecoration(
                  color: const Color(0xFF49D64E),
                  borderRadius: BorderRadius.circular(size * 0.08),
                ),
              ),
            ),
          ),
          Positioned(
            top: size * 0.23,
            child: Icon(
              Icons.accessibility_new_rounded,
              color: Colors.white,
              size: size * 0.34,
            ),
          ),
        ],
      ),
    );
  }
}

class MateyaBrandLockup extends StatelessWidget {
  const MateyaBrandLockup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const MateyaLogoMark(),
        const SizedBox(height: 24),
        const _MateyaWordmark(fontSize: 28),
        const SizedBox(height: 12),
        Text(
          '한국의정과 문화를 나누는\n특별한 여정의 시작',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.43,
          ),
        ),
      ],
    );
  }
}

class _MateyaWordmark extends StatelessWidget {
  const _MateyaWordmark({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        children: const <InlineSpan>[
          TextSpan(
            text: 'Mate',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          TextSpan(
            text: 'Ya',
            style: TextStyle(color: AppColors.brandGreen),
          ),
        ],
      ),
    );
  }
}
