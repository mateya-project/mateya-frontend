import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../domain/mypage_models.dart';
import 'mypage_activity_widgets.dart';
import 'mypage_section_widgets.dart';

class PersonalMyPageView extends StatelessWidget {
  const PersonalMyPageView({
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
              MyPageProfileHeroCard(
                profile: data.profile,
                subtitle:
                    '${data.profile.primaryLanguageLabel} · ${data.profile.primaryCountryLabel}',
              ),
              const SizedBox(height: 16),
              MyPageMetricSection(metrics: data.metrics),
              const SizedBox(height: 16),
              MyPageActionSection(
                items: <MyPageActionItem>[
                  MyPageActionItem(
                    icon: Icons.history_rounded,
                    title: '최근 활동 보기',
                    subtitle: '전체 활동 기록과 통계를 확인합니다.',
                    onTap: onOpenRecentActivities,
                  ),
                  MyPageActionItem(
                    icon: Icons.language_rounded,
                    title: '대표 언어/나라 설정',
                    subtitle: '프로필 상단 노출 정보를 변경합니다.',
                    onTap: onOpenPreferences,
                  ),
                  MyPageActionItem(
                    icon: Icons.person_add_alt_1_rounded,
                    title: '다른 사람 페이지',
                    subtitle: '친구 추가/삭제 흐름을 미리 확인합니다.',
                    onTap: onOpenOtherProfile,
                  ),
                  MyPageActionItem(
                    icon: Icons.no_accounts_rounded,
                    title: '회원 탈퇴',
                    subtitle: 'soft delete 정책과 서명 입력 팝업을 확인합니다.',
                    isDanger: true,
                    onTap: onOpenWithdrawal,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              MyPageBadgeSection(badges: data.badges),
              const SizedBox(height: 16),
              MyPageRecentActivityPreviewSection(
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

class OtherProfileView extends StatelessWidget {
  const OtherProfileView({
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
              MyPageProfileHeroCard(
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
              MyPageMetricSection(metrics: data.metrics),
              const SizedBox(height: 16),
              MyPageBadgeSection(badges: data.badges),
              const SizedBox(height: 16),
              MyPageRecentActivityPreviewSection(
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

class RecentActivitiesView extends StatelessWidget {
  const RecentActivitiesView({
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
              MyPageStatsCard(
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
                MyPageActivityHistoryCard(activity: activity),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class PrimaryPreferencesView extends StatelessWidget {
  const PrimaryPreferencesView({
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
                MyPageSelectionField(
                  label: '대표 언어',
                  value: currentLanguageCode,
                  items: languageOptions,
                  onChanged: onLanguageChanged,
                ),
                const SizedBox(height: 16),
                MyPageSelectionField(
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

class BusinessMyPageView extends StatelessWidget {
  const BusinessMyPageView({
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
              MyPageProfileHeroCard(
                profile: data.profile,
                subtitle: data.profile.placeLabel ?? data.profile.residence,
              ),
              const SizedBox(height: 16),
              MyPageStatsCard(items: data.metrics),
              const SizedBox(height: 16),
              MyPageSectionCard(
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
              MyPageSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '운영중인 체험',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    for (final activity in data.activeExperiences) ...<Widget>[
                      MyPageActivityHistoryCard(activity: activity),
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
