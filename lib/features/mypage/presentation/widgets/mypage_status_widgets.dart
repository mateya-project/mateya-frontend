import 'package:flutter/material.dart';

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
                MateyaSkeletonBlock(height: 140, radius: 18),
                SizedBox(height: 16),
                MateyaSkeletonBlock(height: 124, radius: 18),
                SizedBox(height: 16),
                MateyaSkeletonBlock(height: 210, radius: 18),
                SizedBox(height: 16),
                MateyaSkeletonBlock(height: 300, radius: 18),
              ],
            ),
          ),
        ),
      ],
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
                    child: MateyaButton(label: '다시 시도', onPressed: onRetry),
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
          Text('회원 탈퇴', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '탈퇴 직후 계정은 비활성화되고, 30일 후 개인정보와 활동 데이터는 백엔드 정책에 따라 삭제 또는 익명화됩니다.',
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
                    '개인정보 관리 및 30일 후 최종 삭제 정책에 동의합니다.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '서명 입력',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          MateyaTextField(
            controller: signatureController,
            hintText: '$name 입력',
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
                '탈퇴 요청이 접수되었습니다. 앱 재로그인 전까지 계정은 비활성 상태로 간주됩니다.',
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
                  child: const Text('닫기'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MateyaButton(
                  label: controller.isSubmittingWithdrawal
                      ? '처리 중...'
                      : '탈퇴 요청',
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
