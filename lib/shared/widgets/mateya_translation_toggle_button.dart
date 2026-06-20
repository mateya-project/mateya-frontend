import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

enum MateyaTranslationToggleButtonVariant { chip, inline }

class MateyaTranslationToggleButton extends StatelessWidget {
  const MateyaTranslationToggleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = MateyaTranslationToggleButtonVariant.chip,
  });

  final String label;
  final VoidCallback onPressed;
  final MateyaTranslationToggleButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.brandGreen,
      fontWeight: FontWeight.w600,
    );

    if (variant == MateyaTranslationToggleButtonVariant.inline) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandGreen,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
          minimumSize: const Size(0, 28),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Text(label, style: textStyle),
      );
    }

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brandGreen,
        backgroundColor: AppColors.softGreenBorder,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: const BorderSide(color: AppColors.brandGreen),
        ),
      ),
      child: Text(label, style: textStyle),
    );
  }
}
