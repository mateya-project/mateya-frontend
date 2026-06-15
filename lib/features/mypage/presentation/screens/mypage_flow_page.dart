import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../application/mypage_controller.dart';
import '../../domain/mypage_models.dart';

class MyPageFlowPage extends StatefulWidget {
  const MyPageFlowPage({super.key, required this.controller});

  final MyPageController controller;

  @override
  State<MyPageFlowPage> createState() => _MyPageFlowPageState();
}

class _MyPageFlowPageState extends State<MyPageFlowPage> {
  final TextEditingController _businessIntroductionController =
      TextEditingController();
  final TextEditingController _withdrawalSignatureController =
      TextEditingController();

  int _lastToastVersion = 0;
  bool _withdrawalAgreement = false;
  String? _selectedLanguageCode;
  String? _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _businessIntroductionController.addListener(_handleLocalFieldChanged);
    widget.controller.addListener(_handleControllerChanged);
    widget.controller.initialize();
  }

  @override
  void didUpdateWidget(covariant MyPageFlowPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }
    oldWidget.controller.removeListener(_handleControllerChanged);
    widget.controller.addListener(_handleControllerChanged);
    widget.controller.initialize();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _businessIntroductionController.removeListener(_handleLocalFieldChanged);
    _businessIntroductionController.dispose();
    _withdrawalSignatureController.dispose();
    super.dispose();
  }

  void _handleLocalFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    final controller = widget.controller;
    if (controller.toastMessage != null &&
        controller.toastVersion != _lastToastVersion) {
      _lastToastVersion = controller.toastVersion;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.toastMessage!)));
      controller.clearToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        _syncFormValues();
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: switch (widget.controller.phase) {
            MyPageAsyncPhase.idle ||
            MyPageAsyncPhase.loading => const _LoadingView(),
            MyPageAsyncPhase.networkError ||
            MyPageAsyncPhase.serverError => _RetryView(
              message: widget.controller.errorMessage ?? '마이페이지를 불러오지 못했어요.',
              onRetry: widget.controller.retry,
            ),
            MyPageAsyncPhase.success ||
            MyPageAsyncPhase.validationError => _buildRouteView(),
          },
        );
      },
    );
  }

  Widget _buildRouteView() {
    final controller = widget.controller;

    return switch (controller.route) {
      MyPageRoute.personalHome => _PersonalMyPageView(
        key: const ValueKey<String>('personal-home'),
        data: controller.personalPage!,
        onOpenRecentActivities: controller.openRecentActivities,
        onOpenPreferences: controller.openPrimaryPreferences,
        onOpenOtherProfile: controller.openOtherProfile,
        onOpenWithdrawal: _openWithdrawalDialog,
      ),
      MyPageRoute.otherProfile => _OtherProfileView(
        key: const ValueKey<String>('other-profile'),
        data: controller.otherProfile!,
        isBusy: controller.isUpdatingFriendship,
        onBack: controller.openPersonalHome,
        onFriendTap: controller.toggleFriendship,
      ),
      MyPageRoute.recentActivities => _RecentActivitiesView(
        key: const ValueKey<String>('recent-activities'),
        data: controller.recentActivity!,
        onBack: controller.openPersonalHome,
      ),
      MyPageRoute.primaryPreferences => _PrimaryPreferencesView(
        key: const ValueKey<String>('primary-preferences'),
        currentLanguageCode: _selectedLanguageCode,
        currentCountryCode: _selectedCountryCode,
        languageOptions: controller.languageOptions,
        countryOptions: controller.countryOptions,
        isSaving: controller.isSavingPreferences,
        errorText: controller.phase == MyPageAsyncPhase.validationError
            ? controller.errorMessage
            : null,
        onBack: controller.openPersonalHome,
        onLanguageChanged: (value) => setState(() {
          _selectedLanguageCode = value;
        }),
        onCountryChanged: (value) => setState(() {
          _selectedCountryCode = value;
        }),
        onSave: () {
          controller.updatePrimaryPreferences(
            languageCode: _selectedLanguageCode ?? '',
            countryCode: _selectedCountryCode ?? '',
          );
        },
      ),
      MyPageRoute.businessHome => _BusinessMyPageView(
        key: const ValueKey<String>('business-home'),
        data: controller.businessPage!,
        introductionController: _businessIntroductionController,
        isSaving: controller.isSavingBusinessIntroduction,
        errorText: controller.phase == MyPageAsyncPhase.validationError
            ? controller.errorMessage
            : null,
        onSave: () {
          controller.updateBusinessIntroduction(
            _businessIntroductionController.text,
          );
        },
      ),
      MyPageRoute.withdrawal => const SizedBox.shrink(),
    };
  }

  void _syncFormValues() {
    final personalProfile = widget.controller.personalPage?.profile;
    if (personalProfile != null) {
      _selectedLanguageCode ??= personalProfile.primaryLanguageCode;
      _selectedCountryCode ??= personalProfile.primaryCountryCode;
    }

    final businessIntroduction =
        widget.controller.businessPage?.profile.oneLineIntroduction ?? '';
    if (_businessIntroductionController.text != businessIntroduction) {
      _businessIntroductionController.value = TextEditingValue(
        text: businessIntroduction,
        selection: TextSelection.collapsed(offset: businessIntroduction.length),
      );
    }
  }

  Future<void> _openWithdrawalDialog() async {
    widget.controller.clearError();
    _withdrawalAgreement = false;
    _withdrawalSignatureController.clear();

    await showDialog<void>(
      context: context,
      barrierDismissible: !widget.controller.isSubmittingWithdrawal,
      builder: (dialogContext) {
        final name = widget.controller.personalPage?.profile.name ?? '';

        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.primaryRadius),
          ),
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              final errorText =
                  widget.controller.phase == MyPageAsyncPhase.validationError
                  ? widget.controller.errorMessage
                  : null;

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '회원 탈퇴',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '탈퇴 직후 계정은 비활성화되고, 30일 후 개인정보와 활동 데이터는 백엔드 정책에 따라 삭제 또는 익명화됩니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: widget.controller.isSubmittingWithdrawal
                          ? null
                          : () {
                              setState(() {
                                _withdrawalAgreement = !_withdrawalAgreement;
                              });
                            },
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _withdrawalAgreement,
                            onChanged: widget.controller.isSubmittingWithdrawal
                                ? null
                                : (value) {
                                    setState(() {
                                      _withdrawalAgreement = value ?? false;
                                    });
                                  },
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MateyaTextField(
                      controller: _withdrawalSignatureController,
                      hintText: '$name 입력',
                      errorText: errorText,
                    ),
                    if (widget.controller.withdrawalCompleted) ...<Widget>[
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.brandGreen),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.controller.isSubmittingWithdrawal
                                ? null
                                : () => Navigator.of(dialogContext).pop(),
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
                            label: widget.controller.isSubmittingWithdrawal
                                ? '처리 중...'
                                : '탈퇴 요청',
                            enabled: !widget.controller.isSubmittingWithdrawal,
                            tone: MateyaButtonTone.dark,
                            onPressed: () {
                              widget.controller.submitWithdrawal(
                                hasAgreed: _withdrawalAgreement,
                                signature: _withdrawalSignatureController.text,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _PersonalMyPageView extends StatelessWidget {
  const _PersonalMyPageView({
    super.key,
    required this.data,
    required this.onOpenRecentActivities,
    required this.onOpenPreferences,
    required this.onOpenOtherProfile,
    required this.onOpenWithdrawal,
  });

  final PersonalMyPageData data;
  final VoidCallback onOpenRecentActivities;
  final VoidCallback onOpenPreferences;
  final VoidCallback onOpenOtherProfile;
  final VoidCallback onOpenWithdrawal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const MateyaHeader.noBackArrow(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              _ProfileHeroCard(
                profile: data.profile,
                subtitle:
                    '${data.profile.primaryLanguageLabel} · ${data.profile.primaryCountryLabel}',
              ),
              const SizedBox(height: 16),
              _MetricSection(metrics: data.metrics),
              const SizedBox(height: 16),
              _ActionSection(
                items: <_ActionItem>[
                  _ActionItem(
                    icon: Icons.history_rounded,
                    title: '최근 활동 보기',
                    subtitle: '전체 활동 기록과 통계를 확인합니다.',
                    onTap: onOpenRecentActivities,
                  ),
                  _ActionItem(
                    icon: Icons.language_rounded,
                    title: '대표 언어/나라 설정',
                    subtitle: '프로필 상단 노출 정보를 변경합니다.',
                    onTap: onOpenPreferences,
                  ),
                  _ActionItem(
                    icon: Icons.person_add_alt_1_rounded,
                    title: '다른 사람 페이지',
                    subtitle: '친구 추가/삭제 흐름을 미리 확인합니다.',
                    onTap: onOpenOtherProfile,
                  ),
                  _ActionItem(
                    icon: Icons.no_accounts_rounded,
                    title: '회원 탈퇴',
                    subtitle: 'soft delete 정책과 서명 입력 팝업을 확인합니다.',
                    isDanger: true,
                    onTap: onOpenWithdrawal,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _BadgeSection(badges: data.badges),
              const SizedBox(height: 16),
              _RecentActivityPreviewSection(
                activities: data.recentActivities,
                onViewAll: onOpenRecentActivities,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OtherProfileView extends StatelessWidget {
  const _OtherProfileView({
    super.key,
    required this.data,
    required this.isBusy,
    required this.onBack,
    required this.onFriendTap,
  });

  final OtherProfileData data;
  final bool isBusy;
  final VoidCallback onBack;
  final VoidCallback onFriendTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              _ProfileHeroCard(
                profile: data.profile,
                subtitle:
                    '${data.profile.primaryLanguageLabel} · ${data.profile.primaryCountryLabel}',
                trailing: SizedBox(
                  width: 132,
                  child: MateyaButton(
                    label: isBusy
                        ? '처리 중...'
                        : data.isFriend
                        ? '친구 삭제'
                        : '친구 추가',
                    enabled: !isBusy,
                    tone: data.isFriend
                        ? MateyaButtonTone.dark
                        : MateyaButtonTone.brand,
                    onPressed: onFriendTap,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _MetricSection(metrics: data.metrics),
              const SizedBox(height: 16),
              _BadgeSection(badges: data.badges),
              const SizedBox(height: 16),
              _RecentActivityPreviewSection(
                activities: data.recentActivities,
                onViewAll: () {},
                showButton: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentActivitiesView extends StatelessWidget {
  const _RecentActivitiesView({
    super.key,
    required this.data,
    required this.onBack,
  });

  final RecentActivityData data;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              Text(
                '최근 활동 보기',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '참여/개설 이력을 최근순으로 확인하고, 클래스인 경우에만 리뷰 평점을 노출합니다.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _StatsCard(
                items: <ProfileMetric>[
                  ProfileMetric(
                    label: '전체 활동 수',
                    value: '${data.stats.totalCount}',
                  ),
                  ProfileMetric(
                    label: '개설 활동 수',
                    value: '${data.stats.hostedCount}',
                  ),
                  ProfileMetric(
                    label: '참여 활동 수',
                    value: '${data.stats.joinedCount}',
                  ),
                  ProfileMetric(
                    label: '작성 후기 수',
                    value: '${data.stats.reviewCount}',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final activity in data.activities) ...<Widget>[
                _ActivityHistoryCard(activity: activity),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PrimaryPreferencesView extends StatelessWidget {
  const _PrimaryPreferencesView({
    super.key,
    required this.currentLanguageCode,
    required this.currentCountryCode,
    required this.languageOptions,
    required this.countryOptions,
    required this.isSaving,
    required this.errorText,
    required this.onBack,
    required this.onLanguageChanged,
    required this.onCountryChanged,
    required this.onSave,
  });

  final String? currentLanguageCode;
  final String? currentCountryCode;
  final List<SelectionOption> languageOptions;
  final List<SelectionOption> countryOptions;
  final bool isSaving;
  final String? errorText;
  final VoidCallback onBack;
  final ValueChanged<String?> onLanguageChanged;
  final ValueChanged<String?> onCountryChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '대표 언어 / 대표 나라',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '설정이 완료되면 마이페이지 프로필 영역에 즉시 반영됩니다.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                _SelectionField(
                  label: '대표 언어',
                  value: currentLanguageCode,
                  items: languageOptions,
                  onChanged: onLanguageChanged,
                ),
                const SizedBox(height: 16),
                _SelectionField(
                  label: '대표 나라',
                  value: currentCountryCode,
                  items: countryOptions,
                  onChanged: onCountryChanged,
                ),
                if (errorText != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          errorText!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                MateyaButton(
                  label: isSaving ? '저장 중...' : '설정 완료',
                  enabled: !isSaving,
                  onPressed: onSave,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BusinessMyPageView extends StatelessWidget {
  const _BusinessMyPageView({
    super.key,
    required this.data,
    required this.introductionController,
    required this.isSaving,
    required this.errorText,
    required this.onSave,
  });

  final BusinessMyPageData data;
  final TextEditingController introductionController;
  final bool isSaving;
  final String? errorText;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const MateyaHeader.noBackArrow(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              _ProfileHeroCard(
                profile: data.profile,
                subtitle: data.profile.placeLabel ?? data.profile.residence,
              ),
              const SizedBox(height: 16),
              _StatsCard(items: data.metrics),
              const SizedBox(height: 16),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '한줄소개 수정',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '사업자 소개는 최대 500자까지 저장합니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MateyaTextField(
                      controller: introductionController,
                      hintText: '운영 스타일을 소개해 주세요.',
                      maxLength: 500,
                      maxLines: 5,
                      minLines: 5,
                      errorText: errorText,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${introductionController.text.length}/500',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MateyaButton(
                      label: isSaving ? '저장 중...' : '소개 저장',
                      enabled: !isSaving,
                      onPressed: onSave,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '운영중인 체험',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    for (final activity in data.activeExperiences) ...<Widget>[
                      _ActivityHistoryCard(activity: activity),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.profile,
    required this.subtitle,
    this.trailing,
  });

  final ProfileSummary profile;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _AvatarImage(imageUrl: profile.profileImageUrl, size: 72),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: profile.isActiveWithin30Days
                            ? AppColors.softGreenBorder
                            : AppColors.subtleBackground,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        profile.isActiveWithin30Days ? '30일 내 접속' : '최근 접속 없음',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: profile.isActiveWithin30Days
                              ? AppColors.brandGreen
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.residence,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (profile.oneLineIntroduction != null &&
                    profile.oneLineIntroduction!.trim().isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),
                  Text(
                    profile.oneLineIntroduction!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: 12),
            Flexible(child: trailing!),
          ],
        ],
      ),
    );
  }
}

class _MetricSection extends StatelessWidget {
  const _MetricSection({required this.metrics});

  final List<ProfileMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return _StatsCard(items: metrics);
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({required this.items});

  final List<_ActionItem> items;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        children: <Widget>[
          for (var index = 0; index < items.length; index += 1) ...<Widget>[
            _ActionTile(item: items[index]),
            if (index != items.length - 1) const Divider(height: 24),
          ],
        ],
      ),
    );
  }
}

class _BadgeSection extends StatelessWidget {
  const _BadgeSection({required this.badges});

  final List<ActivityBadge> badges;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('뱃지', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: badges
                .map(
                  (badge) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.softGreenBorder,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          badge.label,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.brandGreen,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          badge.categoryLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityPreviewSection extends StatelessWidget {
  const _RecentActivityPreviewSection({
    required this.activities,
    required this.onViewAll,
    this.showButton = true,
  });

  final List<ActivityHistoryEntry> activities;
  final VoidCallback onViewAll;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '활동 이력',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (showButton)
                TextButton(onPressed: onViewAll, child: const Text('전체보기')),
            ],
          ),
          const SizedBox(height: 12),
          for (
            var index = 0;
            index < activities.length;
            index += 1
          ) ...<Widget>[
            _ActivityHistoryCard(activity: activities[index]),
            if (index != activities.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.items});

  final List<ProfileMetric> items;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items
            .map(
              (metric) => SizedBox(
                width: (MediaQuery.sizeOf(context).width - 72) / 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.subtleBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        metric.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        metric.value,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _ActivityHistoryCard extends StatelessWidget {
  const _ActivityHistoryCard({required this.activity});

  final ActivityHistoryEntry activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 176,
                  child: Image.network(
                    activity.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.subtleBackground,
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 34,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    activity.categoryLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              if (activity.isHostedByMe)
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandGreen,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'HOST',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  activity.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: <Widget>[
                    _MetaPill(
                      icon: Icons.calendar_today_rounded,
                      text: activity.dateLabel,
                    ),
                    _MetaPill(
                      icon: Icons.schedule_rounded,
                      text: activity.timeLabel,
                    ),
                    _MetaPill(
                      icon: Icons.group_outlined,
                      text: activity.participantLabel,
                    ),
                    _MetaPill(
                      icon: Icons.payments_outlined,
                      text: activity.priceLabel,
                    ),
                  ],
                ),
                if (activity.rating != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        activity.rating!.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionField extends StatelessWidget {
  const _SelectionField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<SelectionOption> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey<String?>('$label-$value'),
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              borderSide: const BorderSide(color: AppColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              borderSide: const BorderSide(color: AppColors.textPrimary),
            ),
          ),
          items: items
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option.code,
                  child: Text(option.label),
                ),
              )
              .toList(growable: false),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.item});

  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: item.onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.isDanger
                  ? AppColors.error.withValues(alpha: 0.08)
                  : AppColors.subtleBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.icon,
              color: item.isDanger ? AppColors.error : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: item.isDanger ? AppColors.error : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({required this.imageUrl, required this.size});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl == null
            ? Container(
                color: AppColors.subtleBackground,
                child: const Icon(Icons.person_rounded),
              )
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.subtleBackground,
                    child: const Icon(Icons.person_rounded),
                  );
                },
              ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('mypage-loading'),
      children: <Widget>[
        const MateyaHeader.noBackArrow(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: const <Widget>[
              _SkeletonBlock(height: 140),
              SizedBox(height: 16),
              _SkeletonBlock(height: 124),
              SizedBox(height: 16),
              _SkeletonBlock(height: 210),
              SizedBox(height: 16),
              _SkeletonBlock(height: 300),
            ],
          ),
        ),
      ],
    );
  }
}

class _RetryView extends StatelessWidget {
  const _RetryView({required this.message, required this.onRetry});

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

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;
}
