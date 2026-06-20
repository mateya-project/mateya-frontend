import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/details/application/activity_detail_controller.dart';
import 'package:mateya_app/features/details/data/activity_detail_repository.dart';
import 'package:mateya_app/features/details/domain/activity_detail_models.dart';
import 'package:mateya_app/features/details/presentation/screens/activity_detail_page.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/navigation/mateya_route_observer.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('detail page refreshes when returning from another route', (
    tester,
  ) async {
    final repository = _FakeActivityDetailRepository();
    final controller = ActivityDetailController(
      repository: repository,
      activity: _seedActivity(),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        navigatorObservers: <NavigatorObserver>[mateyaRouteObserver],
        home: ActivityDetailPage(controller: controller),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.fetchCount, 1);
    expect(
      find.byKey(const PageStorageKey<String>('activity-detail-scroll')),
      findsOneWidget,
    );

    final navigator = Navigator.of(
      tester.element(find.byType(ActivityDetailPage)),
    );
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Center(child: Text('더미 화면'))),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('더미 화면'), findsOneWidget);

    navigator.pop();
    await tester.pumpAndSettle();

    expect(repository.fetchCount, greaterThanOrEqualTo(2));
  });

  testWidgets('participant sheet exposes approve and remove actions', (
    tester,
  ) async {
    final controller = ActivityDetailController(
      repository: _FakeActivityDetailRepository(),
      activity: _seedActivity(),
    );
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: ActivityParticipantRequestPage(
          controller: controller,
          onOpenOtherProfile: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('참여자A'));
    await tester.pumpAndSettle();

    expect(find.text('프로필 보기'), findsOneWidget);
    expect(find.text('참여자 삭제'), findsOneWidget);

    Navigator.of(tester.element(find.text('프로필 보기'))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('대기중B'));
    await tester.pumpAndSettle();

    expect(find.text('참여 승인'), findsOneWidget);
    expect(find.text('신청 취소'), findsOneWidget);
  });
}

class _FakeActivityDetailRepository implements ActivityDetailRepository {
  int fetchCount = 0;

  @override
  Future<ActivityDetail> fetchDetail(ActivityItem activity) async {
    fetchCount += 1;
    return ActivityDetail(
      activity: activity,
      imageUrls: const <String>['https://example.com/hero.jpg'],
      locationLabel: '서울 서초구',
      host: const ActivityHostProfile(
        userId: 'host-1',
        name: '호스트',
        localizedName: 'Host',
        locationLabel: 'Language Korean · Korea',
      ),
      description: '상세 설명',
      shareUrl: 'https://mateya.app/activities/test-1',
      participants: const <ActivityParticipant>[
        ActivityParticipant(
          id: 'participant-1',
          name: '참여자A',
          residenceLabel: '서울 성동구',
        ),
      ],
      pendingParticipants: const <ActivityParticipant>[
        ActivityParticipant(
          id: 'participant-2',
          name: '대기중B',
          residenceLabel: '서울 마포구',
        ),
      ],
      reviews: const <ActivityReview>[],
    );
  }

  @override
  Future<bool> toggleFavorite({
    required String activityId,
    required bool isFavorite,
  }) async {
    return !isFavorite;
  }

  @override
  Future<ActivityDetail> requestJoin({required ActivityDetail detail}) async {
    return detail;
  }

  @override
  Future<ActivityDetail> approvePendingParticipant({
    required ActivityDetail detail,
    required String participantId,
  }) async {
    return detail.copyWith(
      participants: <ActivityParticipant>[
        ...detail.participants,
        ...detail.pendingParticipants.where((item) => item.id == participantId),
      ],
      pendingParticipants: detail.pendingParticipants
          .where((item) => item.id != participantId)
          .toList(growable: false),
    );
  }

  @override
  Future<ActivityDetail> removeApprovedParticipant({
    required ActivityDetail detail,
    required String participantId,
  }) async {
    return detail.copyWith(
      participants: detail.participants
          .where((item) => item.id != participantId)
          .toList(growable: false),
    );
  }

  @override
  Future<ActivityDetail> removePendingParticipant({
    required ActivityDetail detail,
    required String participantId,
  }) async {
    return detail.copyWith(
      pendingParticipants: detail.pendingParticipants
          .where((item) => item.id != participantId)
          .toList(growable: false),
    );
  }

  @override
  Future<HelpfulToggleState> toggleHelpful({required String reviewId}) async {
    return const HelpfulToggleState(helpful: true, helpfulCount: 1);
  }

  @override
  Future<ActivityReview> fetchReview({
    required String reviewId,
    required bool original,
  }) async {
    return ActivityReview(
      id: reviewId,
      authorName: '나',
      submittedAt: DateTime(2026, 6, 20),
      rating: 5,
      originalText: '원문',
      translatedText: original ? null : '번역문',
      canToggleTranslation: true,
      isTranslationVisible: !original,
    );
  }

  @override
  Future<ActivityReview> submitReview({
    required String activityId,
    required int rating,
    required String body,
    List<String> imageUrls = const <String>[],
  }) async {
    return ActivityReview(
      id: 'review-1',
      authorName: '나',
      submittedAt: DateTime(2026, 6, 20),
      rating: rating,
      originalText: body,
      imageUrls: imageUrls,
    );
  }

  @override
  Future<ActivityReview> updateReview({
    required String reviewId,
    required int rating,
    required String body,
    List<String> imageUrls = const <String>[],
  }) async {
    return ActivityReview(
      id: reviewId,
      authorName: '나',
      submittedAt: DateTime(2026, 6, 20),
      rating: rating,
      originalText: body,
      imageUrls: imageUrls,
    );
  }

  @override
  Future<void> deleteReview({required String reviewId}) async {}
}

ActivityItem _seedActivity() {
  return ActivityItem(
    id: 'test-1',
    categoryId: 'culture',
    categoryLabel: '문화/전통',
    title: '테스트 활동',
    place: '서울',
    startAt: DateTime(2026, 6, 20, 10),
    endAt: DateTime(2026, 6, 20, 12),
    price: 10000,
    rating: 4.8,
    participantCount: 1,
    participantCapacity: 4,
    distanceKm: 2,
    audiences: const <ActivityAudienceOption>{ActivityAudienceOption.everyone},
    languages: const <String>{'ko'},
    statuses: const <ActivityStatusOption>{ActivityStatusOption.recruiting},
    imageUrl: 'https://example.com/cover.jpg',
  );
}
