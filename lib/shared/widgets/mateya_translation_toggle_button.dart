import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class MateyaTranslationToggleButton extends StatelessWidget {
  const MateyaTranslationToggleButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.brandGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
