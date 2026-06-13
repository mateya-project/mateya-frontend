import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

enum MateyaButtonTone { brand, dark }

class MateyaButton extends StatelessWidget {
  const MateyaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.tone = MateyaButtonTone.brand,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final MateyaButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = enabled
        ? switch (tone) {
            MateyaButtonTone.brand => AppColors.brandGreen,
            MateyaButtonTone.dark => AppColors.darkButton,
          }
        : AppColors.disabledButton;
    final foregroundColor = enabled ? Colors.white : AppColors.disabledText;

    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              tone == MateyaButtonTone.dark
                  ? AppSpacing.fieldRadius
                  : AppSpacing.primaryRadius,
            ),
          ),
          textStyle: theme.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: foregroundColor,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
