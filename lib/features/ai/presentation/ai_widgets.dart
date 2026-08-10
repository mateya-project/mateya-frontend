import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/theme/app_tokens.dart';

abstract final class AiColors {
  static const purple50 = Color(0xFFF8F7FF);
  static const purple100 = Color(0xFFF0EEFF);
  static const purple200 = Color(0xFFE7E4FE);
  static const purple300 = Color(0xFFCFC9FD);
  static const purple600 = Color(0xFF6759F1);
  static const purple800 = Color(0xFF3325C5);
}

class AiRobotAvatar extends StatelessWidget {
  const AiRobotAvatar({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AiColors.purple600, AiColors.purple800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x336759F1),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(size * 0.04),
        child: SvgPicture.asset(
          'assets/images/mateya_ai_travel_guide.svg',
          width: size * 0.92,
          height: size * 0.92,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class AiPrimaryButton extends StatelessWidget {
  const AiPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AiColors.purple600,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: Icon(icon ?? Icons.auto_awesome_rounded, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class AiOutlinedButton extends StatelessWidget {
  const AiOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AiColors.purple800,
        side: const BorderSide(color: AiColors.purple300),
        minimumSize: const Size(0, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 17),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class AiEvidenceNotice extends StatelessWidget {
  const AiEvidenceNotice({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.info_outline_rounded, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
