import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/details/domain/activity_detail_models.dart';
import 'package:mateya_app/features/details/presentation/widgets/activity_detail_primitives.dart';
import 'package:mateya_app/features/details/presentation/widgets/activity_detail_sections.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('detail bottom bar does not render share button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: DetailBottomBar(
            detail: _detail(),
            onFavoriteTap: () async {},
            onJoinTap: () async {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.share_outlined), findsNothing);
  });

  testWidgets('detail bottom bar renders animated favorite button', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: DetailBottomBar(
            detail: _detail(),
            onFavoriteTap: () async {},
            onJoinTap: () async {},
          ),
        ),
      ),
    );

    expect(find.byType(BottomGlyphButton), findsOneWidget);
    expect(find.byType(AnimatedToggleActionButton), findsOneWidget);
  });
}

ActivityDetail _detail() {
  return ActivityDetail(
    activity: ActivityItem(
      id: 'activity-1',
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
      audiences: const <ActivityAudienceOption>{
        ActivityAudienceOption.everyone,
      },
      languages: const <String>{'ko'},
      statuses: const <ActivityStatusOption>{ActivityStatusOption.recruiting},
      imageUrl: 'https://example.com/cover.jpg',
    ),
    imageUrls: const <String>['https://example.com/cover.jpg'],
    locationLabel: '서울',
    host: const ActivityHostProfile(
      userId: 'host-1',
      name: '호스트',
      localizedName: 'Host',
      locationLabel: 'Language Korean · Korea',
    ),
    description: '상세 설명',
    shareUrl: 'https://mateya.app/activities/activity-1',
    participants: const <ActivityParticipant>[],
    pendingParticipants: const <ActivityParticipant>[],
    reviews: const <ActivityReview>[],
  );
}
