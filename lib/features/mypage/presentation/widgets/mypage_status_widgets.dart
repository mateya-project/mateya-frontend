import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_skeleton.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../application/mypage_controller.dart';
import '../../domain/mypage_models.dart';

class MyPageLoadingView extends StatelessWidget {
  const MyPageLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('mypage-loading'),
      children: <Widget>[
        const MateyaHeader.noBackArrow(),
        Expanded(
          child: MateyaSkeleton(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: const <Widget>[
                _MyPageProfileHeroSkeleton(),
                SizedBox(height: 16),
                _MyPageMetricStripSkeleton(),
                SizedBox(height: 16),
                _MyPageBadgeSectionSkeleton(),
                SizedBox(height: 32),
                _MyPageRecentActivitiesSkeleton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MyPageProfileHeroSkeleton extends StatelessWidget {
  const _MyPageProfileHeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MateyaSkeletonBlock(width: 72, height: 72, radius: 36),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MateyaSkeletonBlock(height: 24, width: 118, radius: 12),
                SizedBox(height: 10),
                MateyaSkeletonBlock(height: 28, width: 92, radius: 14),
                SizedBox(height: 12),
                MateyaSkeletonBlock(height: 18, width: 142, radius: 9),
                SizedBox(height: 8),
                MateyaSkeletonBlock(height: 16, width: 126, radius: 8),
              ],
            ),
          ),
          SizedBox(width: 12),
          MateyaSkeletonBlock(width: 40, height: 40, radius: 20),
        ],
      ),
    );
  }
}

class _MyPageMetricStripSkeleton extends StatelessWidget {
  const _MyPageMetricStripSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _MyPageMetricChipSkeleton(),
          _MyPageMetricChipSkeleton(),
          _MyPageMetricChipSkeleton(),
          _MyPageMetricChipSkeleton(),
        ],
      ),
    );
  }
}

class _MyPageMetricChipSkeleton extends StatelessWidget {
  const _MyPageMetricChipSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 142,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MateyaSkeletonBlock(height: 14, width: 58, radius: 7),
          SizedBox(height: 10),
          MateyaSkeletonBlock(height: 22, width: 78, radius: 11),
        ],
      ),
    );
  }
}

class _MyPageBadgeSectionSkeleton extends StatelessWidget {
  const _MyPageBadgeSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MateyaSkeletonBlock(height: 22, width: 44, radius: 11),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _MyPageBadgeChipSkeleton(width: 104),
              _MyPageBadgeChipSkeleton(width: 128),
              _MyPageBadgeChipSkeleton(width: 118),
              _MyPageBadgeChipSkeleton(width: 138),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyPageBadgeChipSkeleton extends StatelessWidget {
  const _MyPageBadgeChipSkeleton({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MateyaSkeletonBlock(height: 18, width: double.infinity, radius: 9),
          SizedBox(height: 8),
          MateyaSkeletonBlock(height: 14, width: 72, radius: 7),
        ],
      ),
    );
  }
}

class _MyPageRecentActivitiesSkeleton extends StatelessWidget {
  const _MyPageRecentActivitiesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: MateyaSkeletonBlock(height: 22, width: 82, radius: 11),
              ),
              SizedBox(width: 16),
              MateyaSkeletonBlock(height: 18, width: 56, radius: 9),
            ],
          ),
          SizedBox(height: 12),
          _MyPageActivityCardSkeleton(),
          SizedBox(height: 14),
          _MyPageActivityCardSkeleton(),
        ],
      ),
    );
  }
}

class _MyPageActivityCardSkeleton extends StatelessWidget {
  const _MyPageActivityCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MateyaSkeletonBlock(height: 176, radius: 16),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MateyaSkeletonBlock(height: 22, width: 214, radius: 11),
                SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: <Widget>[
                    MateyaSkeletonBlock(height: 24, width: 88, radius: 12),
                    MateyaSkeletonBlock(height: 24, width: 88, radius: 12),
                    MateyaSkeletonBlock(height: 24, width: 96, radius: 12),
                    MateyaSkeletonBlock(height: 24, width: 82, radius: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyPageRetryView extends StatelessWidget {
  const MyPageRetryView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      key: const ValueKey<String>('mypage-retry'),
      children: <Widget>[
        const MateyaHeader.noBackArrow(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 42,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: 180,
                    child: MateyaButton(
                      label: l10n.commonRetry,
                      onPressed: onRetry,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyPageWithdrawalDialog extends StatelessWidget {
  const MyPageWithdrawalDialog({
    super.key,
    required this.controller,
    required this.signatureController,
    required this.withdrawalAgreement,
    required this.onAgreementChanged,
    required this.onClose,
  });

  final MyPageController controller;
  final TextEditingController signatureController;
  final bool withdrawalAgreement;
  final ValueChanged<bool> onAgreementChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = controller.personalPage?.profile.name ?? '';
    final errorText = controller.phase == MyPageAsyncPhase.validationError
        ? controller.errorMessage
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.mypageWithdrawalTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.mypageWithdrawalDescription,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: controller.isSubmittingWithdrawal
                ? null
                : () => onAgreementChanged(!withdrawalAgreement),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: withdrawalAgreement,
                  onChanged: controller.isSubmittingWithdrawal
                      ? null
                      : (value) => onAgreementChanged(value ?? false),
                  activeColor: AppColors.brandGreen,
                ),
                Expanded(
                  child: Text(
                    l10n.mypageWithdrawalAgreementCheckbox,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.mypageWithdrawalSignatureLabel,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          MateyaTextField(
            controller: signatureController,
            hintText: l10n.mypageWithdrawalSignatureHint(name),
            errorText: errorText,
          ),
          if (controller.withdrawalCompleted) ...<Widget>[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.softGreenBorder,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.mypageWithdrawalSubmittedNotice,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.brandGreen),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.isSubmittingWithdrawal ? null : onClose,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.primaryRadius,
                      ),
                    ),
                  ),
                  child: Text(l10n.commonClose),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MateyaButton(
                  label: controller.isSubmittingWithdrawal
                      ? l10n.commonProcessing
                      : l10n.mypageWithdrawalRequest,
                  enabled: !controller.isSubmittingWithdrawal,
                  tone: MateyaButtonTone.dark,
                  onPressed: () {
                    controller.submitWithdrawal(
                      hasAgreed: withdrawalAgreement,
                      signature: signatureController.text,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
