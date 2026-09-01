import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/ai/data/ai_repository.dart';
import 'package:mateya_app/features/ai/domain/ai_models.dart';
import 'package:mateya_app/features/ai/presentation/ai_conversation_flow_page.dart';
import 'package:mateya_app/features/ai/presentation/ai_place_detail_page.dart';
import 'package:mateya_app/features/chat/application/chat_controller.dart';
import 'package:mateya_app/features/chat/data/chat_repository.dart';
import 'package:mateya_app/features/chat/presentation/screens/chat_flow_page.dart';
import 'package:mateya_app/features/create/application/create_controller.dart';
import 'package:mateya_app/features/create/data/create_repository.dart';
import 'package:mateya_app/features/create/domain/create_models.dart';
import 'package:mateya_app/features/create/presentation/screens/create_flow_page.dart';
import 'package:mateya_app/features/details/application/activity_detail_controller.dart';
import 'package:mateya_app/features/details/data/activity_detail_repository.dart';
import 'package:mateya_app/features/details/presentation/screens/activity_detail_page.dart';
import 'package:mateya_app/features/home/application/home_controller.dart';
import 'package:mateya_app/features/home/data/home_repository.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/features/home/presentation/widgets/home_content.dart';
import 'package:mateya_app/features/mypage/application/mypage_controller.dart';
import 'package:mateya_app/features/mypage/data/mypage_repository.dart';
import 'package:mateya_app/features/mypage/presentation/screens/mypage_flow_page.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/features/onboarding/presentation/widgets/onboarding_intro_steps.dart';
import 'package:mateya_app/shared/activity_categories/activity_category_repository.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';
import 'package:mateya_app/shared/widgets/mateya_bottom_navigation.dart';
import 'package:mateya_app/shared/widgets/mateya_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    AuthSessionStore.instance.clear();
    await AuthSessionStore.instance.flush();
  });

  testWidgets('primary home stays safe on compact notched phones', (
    tester,
  ) async {
    await _configureCompactNotchedPhone(tester);
    final controller = HomeController(
      repository: MockHomeRepository(),
      categoryRepository: MockActivityCategoryRepository(),
      flowKind: FlowKind.guest,
    );
    addTearDown(controller.dispose);
    final initialization = controller.initialize();

    await _pumpAuditedApp(
      tester,
      Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              const MateyaHeader.noBackArrow(),
              Expanded(
                child: HomeContent(
                  controller: controller,
                  aiRepository: MockAiRepository(),
                  onActivityTap: (_) {},
                  onAiTap: _noop,
                  onPlaceTap: (_) {},
                ),
              ),
              MateyaBottomNavigation(
                currentTab: MateyaBottomTab.home,
                onHomeTap: _noop,
                onExploreTap: _noop,
                onPlusTap: _noop,
                onChatTap: _noop,
                onProfileTap: _noop,
              ),
            ],
          ),
        ),
      ),
    );
    await initialization;
    await tester.pump();

    expect(find.byType(HomeContent), findsOneWidget);
    _expectNoLayoutFailure(tester);
  });

  testWidgets('chat list stays safe on compact notched phones', (tester) async {
    await _configureCompactNotchedPhone(tester);
    final controller = ChatController(repository: MockChatRepository());
    addTearDown(controller.dispose);
    final initialization = controller.initialize();

    await _pumpAuditedApp(
      tester,
      Scaffold(
        body: ChatFlowPage(
          controller: controller,
          onHomeTap: _noop,
          onExploreTap: _noop,
          onPlusTap: _noop,
          onProfileTap: _noop,
        ),
      ),
    );
    await initialization;
    await tester.pump();

    expect(find.byType(ChatFlowPage), findsOneWidget);
    _expectNoLayoutFailure(tester);
  });

  testWidgets('AI chat stays safe on compact notched phones', (tester) async {
    await _configureCompactNotchedPhone(tester);
    await _pumpAuditedApp(
      tester,
      AiConversationFlowPage(
        repository: MockAiRepository(includeRecommendationOnCreate: true),
        seed: const AiConversationSeed(
          entryPoint: 'PLACE_DETAIL',
          anchorPlaceId: '1',
          anchorPlaceName: '경복궁',
        ),
      ),
    );

    expect(find.byType(AiConversationFlowPage), findsOneWidget);
    _expectNoLayoutFailure(tester);
  });

  testWidgets('AI place detail stays safe on compact notched phones', (
    tester,
  ) async {
    await _configureCompactNotchedPhone(tester);
    await _pumpAuditedApp(
      tester,
      AiPlaceDetailPage(
        repository: MockAiRepository(),
        placeId: '2',
        onAskAi: (_) {},
        onCreateActivity: (_) {},
        onActivityTap: (_) {},
      ),
    );

    expect(find.byType(AiPlaceDetailPage), findsOneWidget);
    _expectNoLayoutFailure(tester);
  });

  testWidgets('meeting creation stays safe on compact notched phones', (
    tester,
  ) async {
    await _configureCompactNotchedPhone(tester);
    final controller = CreateController(
      repository: MockCreateRepository(),
      categoryRepository: MockActivityCategoryRepository(),
      flowType: CreateFlowType.group,
    );

    await _pumpAuditedApp(tester, CreateFlowPage(controller: controller));

    expect(find.byType(CreateFlowPage), findsOneWidget);
    _expectNoLayoutFailure(tester);
  });

  testWidgets('activity detail stays safe on compact notched phones', (
    tester,
  ) async {
    await _configureCompactNotchedPhone(tester);
    final controller = ActivityDetailController(
      repository: MockActivityDetailRepository(),
      activity: ActivityItem(
        id: 'layout-audit',
        categoryId: 'culture',
        categoryLabel: '문화/전통',
        title: '함께 걸으며 발견하는 긴 이름의 로컬 문화 산책 모임',
        place: '서울특별시 종로구 서촌 일대',
        startAt: DateTime(2026, 9, 20, 10),
        endAt: DateTime(2026, 9, 20, 13),
        price: 10000,
        rating: 4.8,
        participantCount: 4,
        participantCapacity: 8,
        distanceKm: 2,
        audiences: const <ActivityAudienceOption>{
          ActivityAudienceOption.everyone,
        },
        languages: const <String>{'ko', 'en'},
        statuses: const <ActivityStatusOption>{ActivityStatusOption.recruiting},
      ),
    );

    await _pumpAuditedApp(tester, ActivityDetailPage(controller: controller));

    expect(find.byType(ActivityDetailPage), findsOneWidget);
    _expectNoLayoutFailure(tester);
  });

  testWidgets('profile stays safe on compact notched phones', (tester) async {
    await _configureCompactNotchedPhone(tester);
    final controller = MyPageController(
      repository: MockMyPageRepository(),
      flowKind: FlowKind.guest,
    );
    addTearDown(controller.dispose);

    await _pumpAuditedApp(
      tester,
      MyPageFlowPage(controller: controller, onRootBack: _noop),
    );

    expect(find.byType(MyPageFlowPage), findsOneWidget);
    _expectNoLayoutFailure(tester);
  });

  testWidgets('onboarding stays safe on compact notched phones', (
    tester,
  ) async {
    await _configureCompactNotchedPhone(tester);
    await _pumpAuditedApp(
      tester,
      Scaffold(
        body: SafeArea(
          child: WelcomeStepView(onGuestTap: _noop, onHostTap: _noop),
        ),
      ),
    );

    expect(find.byType(WelcomeStepView), findsOneWidget);
    _expectNoLayoutFailure(tester);
  });
}

Future<void> _configureCompactNotchedPhone(WidgetTester tester) async {
  tester.view.physicalSize = const Size(375, 667);
  tester.view.devicePixelRatio = 1;
  tester.view.viewPadding = const FakeViewPadding(top: 47, bottom: 34);
  tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetViewPadding);
  addTearDown(tester.view.resetPadding);
}

Future<void> _pumpAuditedApp(WidgetTester tester, Widget home) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: buildMateyaTheme(),
      locale: const Locale('ko'),
      supportedLocales: MateyaLocalizations.supportedLocales,
      localizationsDelegates: MateyaLocalizations.delegates,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.3)),
        child: child!,
      ),
      home: home,
    ),
  );
  // Several production screens contain intentional looping motion. A bounded
  // pump lets repository delays complete without waiting forever for those
  // animations to settle.
  await tester.pump(const Duration(seconds: 1));
}

void _expectNoLayoutFailure(WidgetTester tester) {
  expect(tester.takeException(), isNull);
}

void _noop() {}
