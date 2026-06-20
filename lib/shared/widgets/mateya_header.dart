import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../preferences/mateya_language_preferences.dart';
import '../theme/app_tokens.dart';
import 'mateya_language_dialog.dart';
import 'mateya_report_sheet.dart';

enum MateyaHeaderVariant { noBackArrow, backArrow, chatDetail }

class MateyaHeader extends StatelessWidget {
  const MateyaHeader.noBackArrow({super.key, this.onLanguageTap})
    : variant = MateyaHeaderVariant.noBackArrow,
      onBack = null,
      onReportTap = null,
      title = null,
      subtitle = null;

  const MateyaHeader.backArrow({
    super.key,
    this.onBack,
    this.onLanguageTap,
    this.onReportTap,
  }) : variant = MateyaHeaderVariant.backArrow,
       title = null,
       subtitle = null;

  const MateyaHeader.chatDetail({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
    this.onLanguageTap,
    this.onReportTap,
  }) : variant = MateyaHeaderVariant.chatDetail;

  final MateyaHeaderVariant variant;
  final VoidCallback? onBack;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onReportTap;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.headerHeight,
      child: switch (variant) {
        MateyaHeaderVariant.noBackArrow => _LogoHeader(
          onLanguageTap: onLanguageTap,
        ),
        MateyaHeaderVariant.backArrow => _BackArrowHeader(
          onBack: onBack,
          onLanguageTap: onLanguageTap,
          onReportTap: onReportTap,
        ),
        MateyaHeaderVariant.chatDetail => _ChatDetailHeader(
          title: title!,
          subtitle: subtitle!,
          onBack: onBack,
          onLanguageTap: onLanguageTap,
          onReportTap: onReportTap,
        ),
      },
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader({required this.onLanguageTap});

  final VoidCallback? onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: <Widget>[
          const Center(child: _MateyaTextLogo()),
          Align(
            alignment: Alignment.centerRight,
            child: _LanguageButton(onTap: onLanguageTap),
          ),
        ],
      ),
    );
  }
}

class _BackArrowHeader extends StatelessWidget {
  const _BackArrowHeader({
    required this.onBack,
    required this.onLanguageTap,
    required this.onReportTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onReportTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: _HeaderGlyphButton(
              onTap: onBack,
              icon: Icons.arrow_back_rounded,
              size: 32,
              color: AppColors.textPrimary,
            ),
          ),
          const Center(child: _MateyaTextLogo()),
          Align(
            alignment: Alignment.centerRight,
            child: _HeaderTrailingActions(
              onReportTap: onReportTap,
              onLanguageTap: onLanguageTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatDetailHeader extends StatelessWidget {
  const _ChatDetailHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onLanguageTap,
    required this.onReportTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onReportTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: _HeaderGlyphButton(
              onTap: onBack,
              icon: Icons.arrow_back_rounded,
              size: 34,
              color: AppColors.textPrimary,
            ),
          ),
          Positioned(
            left: 66,
            right: onReportTap == null ? 66 : 108,
            top: 16,
            bottom: 16,
            child: _ChatDetailTitle(title: title, subtitle: subtitle),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _HeaderTrailingActions(
              onReportTap: onReportTap,
              onLanguageTap: onLanguageTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderTrailingActions extends StatelessWidget {
  const _HeaderTrailingActions({
    required this.onReportTap,
    required this.onLanguageTap,
  });

  final VoidCallback? onReportTap;
  final VoidCallback? onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (onReportTap != null) ...<Widget>[
          _HeaderReportButton(onTap: onReportTap),
          const SizedBox(width: 8),
        ],
        _LanguageButton(onTap: onLanguageTap),
      ],
    );
  }
}

class _HeaderReportButton extends StatelessWidget {
  const _HeaderReportButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        highlightShape: BoxShape.circle,
        child: SizedBox(
          width: 40,
          height: 40,
          child: const Center(child: MateyaReportIcon()),
        ),
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 2),
        Row(
          children: <Widget>[
            const Icon(
              Icons.groups_2_outlined,
              size: 18,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MateyaTextLogo extends StatelessWidget {
  const _MateyaTextLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/textlogo.svg',
      height: 22,
      width: 92,
      fit: BoxFit.contain,
      semanticsLabel: 'MateYa',
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _HeaderGlyphButton(
      onTap:
          onTap ??
          () async {
            final preferences = MateyaLanguagePreferences.instance;
            final initialLanguageCode = await preferences.currentCode();
            if (!context.mounted) {
              return;
            }
            final selectedCode = await showMateyaLanguageDialog(
              context,
              initialLanguageCode: initialLanguageCode,
            );
            if (selectedCode == null) {
              return;
            }
            await preferences.setCurrentCode(selectedCode);
          },
      icon: Icons.language_rounded,
      size: 32,
      color: const Color(0xFF9CA3AF),
    );
  }
}

class _HeaderGlyphButton extends StatelessWidget {
  const _HeaderGlyphButton({
    required this.onTap,
    required this.icon,
    required this.size,
    required this.color,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        highlightShape: BoxShape.circle,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Icon(icon, size: size, color: color),
          ),
        ),
      ),
    );
  }
}

class MateyaLogoMark extends StatelessWidget {
  const MateyaLogoMark({super.key, this.size = 168});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size * 0.9,
      fit: BoxFit.contain,
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
