import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/application/mypage_controller.dart';
import 'package:mateya_app/features/mypage/data/mypage_repository.dart';
import 'package:mateya_app/features/mypage/domain/mypage_models.dart';
import 'package:mateya_app/features/mypage/presentation/screens/mypage_flow_page.dart';
import 'package:mateya_app/features/mypage/presentation/widgets/mypage_route_views.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';
import 'package:mateya_app/shared/widgets/mateya_button.dart';

void main() {
  testWidgets('mypage flow is wrapped with a top safe area', (tester) async {
    final controller = MyPageController(
      repository: _ImmediateMyPageRepository(),
      flowKind: FlowKind.guest,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
          child: MyPageFlowPage(controller: controller, onRootBack: _noop),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets('other profile retry view keeps a back header', (tester) async {
    var backTapCount = 0;
    final controller = MyPageController(
      repository: _OtherProfileErrorMyPageRepository(),
      flowKind: FlowKind.guest,
      initialOtherProfileUserId: 'blocked-user',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
          child: MyPageFlowPage(
            controller: controller,
            onRootBack: () {
              backTapCount += 1;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('차단한 사용자의 프로필은 조회할 수 없습니다.'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();

    expect(backTapCount, 1);
  });

  testWidgets('non-friend other profile shows block button', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1400);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: OtherProfileView(
          data: const OtherProfileData(
            profile: ProfileSummary(
              id: 'user-2',
              name: '다른 사용자',
              residence: '연남동',
              primaryLanguageCode: 'ko',
              primaryLanguageLabel: '한국어',
              primaryCountryCode: 'kr',
              primaryCountryLabel: '대한민국',
            ),
            metrics: <ProfileMetric>[],
            badges: <ActivityBadge>[],
            recentActivities: <ActivityHistoryEntry>[],
            isFriend: false,
          ),
          isBusy: false,
          onBack: _noop,
          onFriendTap: _noop,
          onBlockTap: _noop,
        ),
      ),
    );

    await tester.pump();

    final button = tester.widget<MateyaButton>(find.byType(MateyaButton));
    expect(button.label, '유저차단하기');
    expect(
      find.byKey(const PageStorageKey<String>('mypage-other-profile-scroll')),
      findsOneWidget,
    );
  });

  testWidgets('friend other profile shows remove friend button', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1400);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: OtherProfileView(
          data: const OtherProfileData(
            profile: ProfileSummary(
              id: 'user-4',
              name: '친구 사용자',
              residence: '연남동',
              primaryLanguageCode: 'ko',
              primaryLanguageLabel: '한국어',
              primaryCountryCode: 'kr',
              primaryCountryLabel: '대한민국',
            ),
            metrics: <ProfileMetric>[],
            badges: <ActivityBadge>[],
            recentActivities: <ActivityHistoryEntry>[],
            isFriend: true,
          ),
          isBusy: false,
          onBack: _noop,
          onFriendTap: _noop,
          onBlockTap: _noop,
        ),
      ),
    );

    await tester.pump();

    final button = tester.widget<MateyaButton>(find.byType(MateyaButton));
    expect(button.label, '친구삭제하기');
  });

  testWidgets('other profile badge section uses non-personal copy', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1400);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: OtherProfileView(
          data: const OtherProfileData(
            profile: ProfileSummary(
              id: 'user-3',
              name: '최성현',
              residence: '마로면',
              primaryLanguageCode: 'ko',
              primaryLanguageLabel: '한국어',
              primaryCountryCode: 'kr',
              primaryCountryLabel: '대한민국',
            ),
            metrics: <ProfileMetric>[],
            badges: <ActivityBadge>[],
            recentActivities: <ActivityHistoryEntry>[],
            isFriend: false,
          ),
          isBusy: false,
          onBack: _noop,
          onFriendTap: _noop,
          onBlockTap: _noop,
        ),
      ),
    );

    await tester.pump();

    expect(find.text('내 뱃지'), findsNothing);
    expect(find.text('획득한 뱃지'), findsOneWidget);
    expect(find.text('아직 공개된 뱃지가 없어요.'), findsOneWidget);
  });

  testWidgets('personal home shows locked overlays for unearned badge slots', (
    tester,
  ) async {
    final controller = MyPageController(
      repository: _ImmediateMyPageRepository(),
      flowKind: FlowKind.guest,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
          child: MyPageFlowPage(controller: controller, onRootBack: _noop),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('mypage-badge-lock-traditional')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('mypage-badge-lock-active_person')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('mypage-badge-lock-festive')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('mypage-badge-lock-tourist')),
      findsOneWidget,
    );
  });
}

void _noop() {}

class _ImmediateMyPageRepository implements MyPageRepository {
  @override
  Future<MyPageBundle> fetchBundle({required bool isBusinessMode}) async {
    return MyPageBundle(
      personalPage: const PersonalMyPageData(
        profile: ProfileSummary(
          id: 'user-1',
          name: '박민정',
          residence: '우만동',
          primaryLanguageCode: 'ko',
          primaryLanguageLabel: '한국어',
          primaryCountryCode: 'kr',
          primaryCountryLabel: '대한민국',
        ),
        metrics: <ProfileMetric>[ProfileMetric(label: '활동 수', value: '2')],
        badges: <ActivityBadge>[],
        recentActivities: <ActivityHistoryEntry>[],
      ),
      otherProfile: const OtherProfileData(
        profile: ProfileSummary(
          id: 'user-2',
          name: '다른 사용자',
          residence: '연남동',
          primaryLanguageCode: 'ko',
          primaryLanguageLabel: '한국어',
          primaryCountryCode: 'kr',
          primaryCountryLabel: '대한민국',
        ),
        metrics: <ProfileMetric>[],
        badges: <ActivityBadge>[],
        recentActivities: <ActivityHistoryEntry>[],
        isFriend: false,
      ),
      recentActivity: const RecentActivityData(
        stats: RecentActivityStats(
          totalCount: 0,
          hostedCount: 0,
          joinedCount: 0,
          reviewCount: 0,
        ),
        activities: <ActivityHistoryEntry>[],
      ),
      businessPage: const BusinessMyPageData(
        profile: ProfileSummary(
          id: 'business-1',
          name: '사업자',
          residence: '서초구',
          primaryLanguageCode: 'ko',
          primaryLanguageLabel: '한국어',
          primaryCountryCode: 'kr',
          primaryCountryLabel: '대한민국',
          oneLineIntroduction: '',
        ),
        metrics: <ProfileMetric>[],
        activeExperiences: <ActivityHistoryEntry>[],
      ),
      languageOptions: const <SelectionOption>[
        SelectionOption(code: 'ko', label: '한국어'),
      ],
      countryOptions: const <SelectionOption>[
        SelectionOption(code: 'kr', label: '대한민국'),
      ],
      consentHistory: const <ConsentHistoryEntry>[],
      blockedUsers: const <BlockedUserSummary>[],
    );
  }

  @override
  Future<OtherProfileData> fetchOtherProfile({
    required String targetUserId,
  }) async {
    return const OtherProfileData(
      profile: ProfileSummary(
        id: 'user-2',
        name: '다른 사용자',
        residence: '연남동',
        primaryLanguageCode: 'ko',
        primaryLanguageLabel: '한국어',
        primaryCountryCode: 'kr',
        primaryCountryLabel: '대한민국',
      ),
      metrics: <ProfileMetric>[],
      badges: <ActivityBadge>[],
      recentActivities: <ActivityHistoryEntry>[],
      isFriend: false,
    );
  }

  @override
  Future<List<BlockedUserSummary>> fetchBlockedUsers() async {
    return const <BlockedUserSummary>[];
  }

  @override
  Future<OtherProfileData> updateFriendship({
    required String targetUserId,
    required bool isFriend,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> blockUser({required String targetUserId}) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> submitWithdrawal({
    required String agreementText,
    String? reason,
  }) async {}

  @override
  Future<void> unblockUser({required String targetUserId}) async {}

  @override
  Future<String> updateActivityRegion({
    required NeighborhoodSelection neighborhood,
  }) async {
    return neighborhood.displayName;
  }

  @override
  Future<BusinessMyPageData> updateBusinessIntroduction({
    required String introduction,
    String? placeName,
    String? placeAddress,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<String> updateProfileImage({required String imagePath}) async {
    return imagePath;
  }

  @override
  Future<PersonalMyPageData> updatePrimaryPreferences({
    required String displayName,
    String? englishName,
    required String languageCode,
    required String countryCode,
  }) async {
    throw UnimplementedError();
  }
}

class _OtherProfileErrorMyPageRepository extends _ImmediateMyPageRepository {
  @override
  Future<OtherProfileData> fetchOtherProfile({required String targetUserId}) {
    throw const MyPageRepositoryException(
      MyPageLoadFailureType.server,
      message: '차단한 사용자의 프로필은 조회할 수 없습니다.',
    );
  }
}
