import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../domain/mypage_models.dart';
import 'mypage_badge_catalog.dart';

class MyPageBadgeCelebrationDialog extends StatelessWidget {
  const MyPageBadgeCelebrationDialog({
    super.key,
    required this.badge,
    required this.onClose,
  });

  final ActivityBadge badge;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final visual = findMyPageBadgeVisual(badge);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.primaryRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              l10n.mypageBadgeUnlockedTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.mypageBadgeUnlockedDescription(badge.categoryLabel),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (visual != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  visual.assetPathFor(true),
                  width: 132,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                ),
              )
            else
              const Icon(
                Icons.workspace_premium_rounded,
                size: 96,
                color: AppColors.brandGreen,
              ),
            const SizedBox(height: 16),
            Text(
              visual?.localizedLabel ?? badge.label,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onClose,
                child: Text(l10n.commonConfirm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
